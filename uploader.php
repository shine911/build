#!/usr/bin/php
<?php

/*******************************************************************************
 * file:        google_drive_upload.php
 * author:      ben servoz
 * description: script to upload files to Google Drive
 * Edited: shine911
*******************************************************************************/
$cAuthCode      =   '';


// configuration
//   google oauth
$client_id = "828759585417-0r9v04om10vd0t0rrnjhpmvgh5ipa63p.apps.googleusercontent.com" ;
$client_secret = "tc-RqmmUlavt6DJYJY8pLCmu" ;
$refresh_token = "4/ce-SrIz4ElyXeTr8WENSfnYznfeg.op-CF06NrJYXdJfo-QBMsztmcEmtjQI" ;
//   chunk size (this HAS to be a multiple of 256KB so only change the last integer)
$chunk_size = 512 * 1024 * 400 ; // this will upload files 200MB at a time
//   miscellaneous
$verbose = true ;	
$file_binary = "/usr/bin/file" ; // used for detecting mime type
//   md5
$check_md5_after_upload = true ;
$md5sum_binary = "/usr/bin/md5sum" ;


// todo: grant URL follow thingy if it hasn't been done already

if( count($argv)<2 || count($argv)>3 || in_array("-h", $argv) || in_array("--help", $argv) ) {
	echo "usage: {$argv[0]} <file_name> [folder_id]\n\n    where <file_name> is the full path to the file that you want to upload to Google Drive.\n      and [folder_id] is the the folder where you want to upload the file (optional, defaults to root)\n\n" ;
	exit( 1 ) ;
}

$file_name = $argv[1] ;
if( !file_exists($file_name) ) {
	echo "ERROR: {$file_name} is not found on the filesystem\n" ;
	exit( 1 ) ;
}

$mime_type = get_mime_type( $file_name ) ;
if( $verbose ) { echo " > mime type detected: {$mime_type}\n" ; }

$folder_id = "" ;
if( count($argv)>2 ) {
	$folder_id = $argv[2] ;
}

// retrieving current access token
$access_token = get_access_token() ;

// we create the file that we will be uploading to with google
if( $verbose ) { echo "> creating file with Google\n" ; }
$location = create_google_file( $file_name ) ;

$file_size = filesize( $file_name ) ;
if( $verbose ) { echo "> uploading {$file_name} to {$location}\n" ; }
if( $verbose ) { echo ">   file size: " . (string)($file_size / pow(1024, 2)) . "MB\n" ; }
if( $verbose ) { echo ">   chunk size: " . (string)($chunk_size / pow(1024, 2)) . "MB\n\n" ; }

$last_response_code = false ;
$final_output = null ;
$last_range = false ;
$transaction_counter = 0 ;
$average_upload_speed = 0 ;
$do_exponential_backoff = false ;
$exponential_backoff_counter = 0 ;
while( $last_response_code===false || $last_response_code=='308' ) {
	$transaction_counter++ ;
	if( $verbose ) { echo "> request {$transaction_counter}\n" ; }

	if( $do_exponential_backoff ) {
		$sleep_for = pow( 2, $exponential_backoff_counter ) ;
		if( $verbose ) { echo ">    exponential backoff kicked in, sleeping for {$sleep_for} and a bit\n" ; }
		sleep( $sleep_for ) ;
		usleep( rand(0, 1000) ) ;
		$exponential_backoff_counter++ ;
		if( $exponential_backoff_counter>5 ) {
			// we've waited too long as per Google's instructions
			echo "ERROR: reached time limit of exponential backoff\n" ;
			exit( 1 ) ;
		}
	}

	// determining what range is next
	$range_start = 0 ;
	$range_end = min( $chunk_size, $file_size - 1 ) ;
	if( $last_range!==false ) {
		$last_range = explode( '-', $last_range ) ;
		$range_start = (int)$last_range[1] + 1 ;
		$range_end = min( $range_start + $chunk_size, $file_size - 1 ) ;
	}
	if( $verbose ) { echo ">   range {$range_start}-{$range_end}/{$file_size}\n" ; }

	$ch = curl_init() ;
	curl_setopt( $ch, CURLOPT_URL, "{$location}" ) ;
	curl_setopt( $ch, CURLOPT_PORT , 443 ) ;
	curl_setopt( $ch, CURLOPT_CUSTOMREQUEST, "PUT" ) ;
	curl_setopt( $ch, CURLOPT_BINARYTRANSFER, 1 ) ;
	// grabbing the data to send
	$to_send = file_get_contents( $file_name, false, NULL, $range_start, ($range_end - $range_start + 1) ) ;
	curl_setopt( $ch, CURLOPT_POSTFIELDS, $to_send ) ;
	curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1) ;
	curl_setopt( $ch, CURLOPT_HEADER, true ) ;
	curl_setopt( $ch, CURLOPT_HTTPHEADER, array("Authorization: Bearer {$access_token}",
	                                            "Content-Length: " . (string)($range_end - $range_start + 1),
	                                            "Content-Type: {$mime_type}",
	                                            "Content-Range: bytes {$range_start}-{$range_end}/{$file_size}") ) ;
	$response = parse_response( curl_exec($ch) ) ;
	$post_transaction_info = curl_getinfo( $ch ) ;
	curl_close( $ch ) ;

	$do_exponential_backoff = false ;
	if( isset($response['code']) ) {
		// checking for expired credentials
		if( $response['code']=="401" ) { // todo: make sure that we also got an invalid credential response
			if( $verbose ) { echo ">   access token expired, getting a new one\n" ; }
			$access_token = get_access_token( true ) ;
			$last_response_code = false ;
		} else if( $response['code']=="308" ) {
			$last_response_code = $response['code'] ;
			$last_range = $response['headers']['range'] ;
			// todo: verify x-range-md5 header to be sure, although I can't seem to find what x-range-md5 is a hash of exactly...
			$exponential_backoff_counter = 0 ;
		} else if( $response['code']=="503" ) { // Google's letting us know we should retry
			$do_exponential_backoff = true ;
			$last_response_code = false ;
		} else if( $response['code']=="200" ) { // we are done!
			$last_response_code = $response['code'] ;
			$final_output = $response ;
		} else {
			echo "ERROR: I have no idea what to do so here's a variable dump & have fun figuring it out.\n" ;
			echo "post_transaction_info\n" ;
			print_r( $post_transaction_info ) ;
			echo "response\n" ;
			print_r( $response ) ;
			exit( 1 ) ;
		}

		$average_upload_speed += (int)$post_transaction_info['speed_upload'] ;
		if( $verbose ) { echo ">   uploaded {$post_transaction_info['size_upload']}B\n" ; }

	} else {
		$do_exponential_backoff = true ;
		$last_response_code = false ;
	}
}

if( $last_response_code!="200" ) {
	echo "ERROR: there's no way we should reach this point\n" ;
	exit( 1 ) ;
}
if( $verbose ) { echo "\n> all done!\n" ; }
$average_upload_speed /= $transaction_counter ;
if( $verbose ) { echo "\n> average upload speed: " . (string)($average_upload_speed / pow(1024, 2)) . "MB/s\n" ; }

$final_output =json_decode( $final_output['body'] ) ;

if( $check_md5_after_upload ) {
	if( $verbose ) { echo "> md5 hash verification " ; }
	$result = exec( "{$md5sum_binary} {$file_name}" ) ;
	$result = trim( $result ) ;
	$result = explode( " ", $result ) ;
	$result = $result[0] ;
	if( $result!=$final_output->md5Checksum ) {
		if( $verbose ) { echo "FAIL\n" ; }
		echo "ERROR: md5 mismatch; local:{$result}, google:{$final_output->md5Checksum}\n" ;
		exit( 1 ) ;
	} else {
		if( $verbose ) { echo "OK\n" ; }
	}
}

echo $final_output->selfLink, "\n" ;

// we made it
exit( 0 )  ;


function get_mime_type( $file_name ) {
	global $file_binary ;

	$result = exec( "{$file_binary} -i -b {$file_name}" ) ;
	$result = trim( $result ) ;
	$result = explode( ";", $result ) ;
	$result = $result[0] ;

	return $result ;
}


function parse_response( $raw_data ) {
	$parsed_response = array( 'code'=>-1, 'headers'=>array(), 'body'=>"" ) ;

	$raw_data = explode( "\r\n", $raw_data ) ;

	$parsed_response['code'] = explode( " ", $raw_data[0] ) ;
	$parsed_response['code'] = $parsed_response['code'][1] ;

	for( $i=1 ; $i<count($raw_data) ; $i++ ) {
		$raw_datum = $raw_data[$i] ;

		$raw_datum = trim( $raw_datum ) ;
		if( $raw_datum!="" ) {
			if( substr_count($raw_datum, ':')>=1 ) {
				$raw_datum = explode( ':', $raw_datum, 2 ) ;
				$parsed_response['headers'][strtolower($raw_datum[0])] = trim( $raw_datum[1] ) ;
			}  else {
				echo "ERROR: we're in the headers section of parsing an HTTP section and no colon was found for line: {$raw_datum}\n" ;
				exit( 1 ) ;
			}
		} else {
			// we've moved to the body section
			if( ($i+1)<count($raw_data) ) {
				for( $j=($i+1) ; $j<count($raw_data) ; $j++ ) {
					$parsed_response['body'] .= $raw_data[$j] . "\n" ;
				}
			}

			// we don't need to continue the $i loop
			break ;
		}
	}

	return $parsed_response ;
}


function get_access_token( $force_refresh=false ) {
    global $client_id, $client_secret, $refresh_token, $verbose ;

    if( $verbose ) { echo "> retrieving access token\n" ; }

    $token_filename = "/tmp/access_token_" . md5( $client_id . $client_secret . $refresh_token ) ;
    $access_token = "" ;
    if( !file_exists($token_filename) || $force_refresh===true ) {
	    // no previous access token, let's get one
	    if( $verbose ) { echo ">   getting new one\n" ; }

	    $ch = curl_init() ;
	    curl_setopt( $ch, CURLOPT_URL, "https://accounts.google.com/o/oauth2/token" ) ;
	    curl_setopt( $ch, CURLOPT_PORT , 443 ) ;
	    curl_setopt( $ch, CURLOPT_POST, 1 ) ;
	    curl_setopt( $ch, CURLOPT_POSTFIELDS, "client_id={$client_id}&client_secret={$client_secret}&refresh_token={$refresh_token}&grant_type=refresh_token" ) ;
	    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 ) ;
	    curl_setopt( $ch, CURLOPT_HEADER, true ) ;
	    curl_setopt( $ch, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded') ) ;

	    $response = curl_exec( $ch ) ;
	    $response = parse_response( $response ) ;

	    // todo: make sure that we got a valid response before retrieving the access token from it

	    $access_token = json_decode( $response['body'] ) ;
	    $access_token = $access_token->access_token ;
	    file_put_contents( $token_filename, $access_token ) ;
	} else {
		// we already have something cached, with some luck it's still valid
	    $access_token = file_get_contents( $token_filename ) ;
	    if( $verbose ) { echo ">   from cache\n" ; }
	}

	if( $access_token=="" ) {
		echo "ERROR: problems getting an access token\n" ;
		exit( 1 ) ;
	}

    return  $access_token ;
}


function create_google_file ( $file_name ) {
	global $access_token, $folder_id, $mime_type ;

	// todo: make mimeType universal
	if( $folder_id=="" ) {
		$post_fields = "{\"title\":\"{$file_name}\",
	                     \"mimeType\":\"{$mime_type}\"}" ;
	} else {
		$post_fields = "{\"title\":\"{$file_name}\",
	                     \"mimeType\":\"{$mime_type}\",
	                     \"parents\": [{\"kind\":\"drive#fileLink\",\"id\":\"{$folder_id}\"}]}" ;
	}

	$ch = curl_init() ;
	curl_setopt( $ch, CURLOPT_URL, "https://www.googleapis.com/upload/drive/v2/files?uploadType=resumable" ) ;
	curl_setopt( $ch, CURLOPT_PORT , 443 ) ;
	curl_setopt( $ch, CURLOPT_POST, 1 ) ;
	curl_setopt( $ch, CURLOPT_POSTFIELDS, $post_fields ) ;
	curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 ) ;
	curl_setopt( $ch, CURLOPT_HEADER, true ) ;
	curl_setopt( $ch, CURLOPT_HTTPHEADER, array("Authorization: Bearer {$access_token}",
	    										"Content-Length: " . strlen($post_fields),
											    "X-Upload-Content-Type: {$mime_type}",
											    "X-Upload-Content-Length: " . filesize($file_name),	
											    "Content-Type: application/json; charset=UTF-8") ) ;
	$response = curl_exec( $ch ) ;
	$response = parse_response( $response ) ;

	// access token expired, let's get a new one and try again
	if( $response['code']=="401" ) { // todo: make sure that we also got an invalid credential response
		$access_token = get_access_token( true ) ;
		return create_google_file( $file_name ) ; // todo: implement recursion depth limit so we don't rescurse to hell
	}

	// error checking
	if( $response['code']!="200" ) {
		echo "ERROR: could not create resumable file\n" ;
		print_r( $response ) ;
		exit( 1 ) ;
	}
	if( !isset($response['headers']['location']) ) {
		echo "ERROR: not location header gotten back\n" ;
		print_r( $response ) ;
		exit( 1 ) ;
	}
	
	return $response['headers']['location'] ;
}

?>
