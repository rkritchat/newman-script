#/bin/bash

env=$1
folders=($(ls -d */))
envFile=""

getEnvFile(){
  target=$1
  currentPath=$2
  for e in $(ls $currentPath)
  do
     if [[ "$e" == *"$targetEnv.postman_environment"* ]];
     then
        envFile=$e
     fi 
  done
}

run_newman(){
 integration_test=$1
 environment=$2
 echo $integration_test
 echo $environment
 echo "statrt-----"
 newman run $integration_test --environment $environment #-r html 
}

for folder in $(ls -d */)
do
   echo "start integration test for $folder"
   getEnvFile $env $(pwd)/$folder
   
   for integration_test_file in $(ls $folder)
   do 
      if [[ "$integration_test_file" == *"postman_collection"* ]];
      then
         echo "newman run $(pwd)/$folder$integration_test_file --environment $(pwd)/$folder$envFile"
         # newman run $(pwd)/$folder$integration_test_file --environment $(pwd)/$folder$envFile -r html
         run_newman $(pwd)/$folder$integration_test_file $(pwd)/$folder$envFile
      fi
   done
done

