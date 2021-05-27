curl -X POST --cookie %1 ^
-u %2:%3 ^
-H content-type:application/xml ^
-H "Jenkins-Crumb:%4" ^
-d @%5 ^
%6/credentials/store/system/domain/_/createCredentials
