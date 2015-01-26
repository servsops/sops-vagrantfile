if [ -f Berksfile.lock ]; then
  berks update; rm -rf cookbooks ; berks vendor cookbooks
else
  berks
  [ -d cookbooks ] && rm -rf cookbooks 
  berks vendor cookbooks
fi
