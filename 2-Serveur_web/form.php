<?php
      $file=fopen("logApache.txt","a");
      fputs($file,$_POST["nom"].PHP_EOL);
      fclose($file);
?>
