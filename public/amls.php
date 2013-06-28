<?php
  $fnmt="mls.txt";
  $mail=strtolower(trim($_POST['email'])) ;
  $eml_pattern="/^([a-z0-9_\.-]+)@([a-z0-9_\.-]+)\.([a-z\.]{2,6})$/";
   
// "/^(?:[a-z0-9]+(?:[-_.]?[a-z0-9-_.]+)?@[a-z0-9]+(?:\.?[a-z0-9-.]+)?\.[a-z]{2,5})$/i";
// "/^([a-z0-9_\.-]+)@([a-z0-9_\.-]+)\.([a-z\.]{2,6})$/"


////////////////////////////////////////////////////////////////
//   for php > 5.2 :
//if(!filter_var($mail, FILTER_VALIDATE_EMAIL)) { echo('<center><font color="red">E-mail contains invalid characters.</font></center>');}

if(!preg_match($eml_pattern, $mail)) {
    echo('<center><font color="red">incorrect e-mail  !</font></center>');
    }
else {
    $content='';
    
    //seach email in file
    $fp = fopen($fnmt, 'a+');
    if (filesize($fnmt)>0) { $content = fread($fp, filesize($fnmt)); }
    
    $isdbl=strpos($content, $mail);
    
    $tf=(bool)$isdbl;
    // add or not add email
    if (!($isdbl===false)) { 
        echo "<font color='red'>Your email " .   $mail. " already in list </font>"; 
    }
    else {
        $content= "\r\n".$mail;
        $test = fwrite($fp,  $content); // write to file
    	if ($test) { echo "Your email " .   $mail. " was added to list"; }
        else { echo 'Error write file';  }
        fclose($fp);
    }
}
?>