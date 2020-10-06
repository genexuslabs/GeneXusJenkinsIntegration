curl -s -X POST --cookie %1 ^
  -u %2:%3 ^
  -H "Jenkins-Crumb:%4" ^
  -H 'content-Type:text/xml' ^
  -d @%5 ^
%6/pluginManager/installNecessaryPlugins