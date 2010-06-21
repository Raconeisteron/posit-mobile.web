#!/bin/bash
URL=http://turing.cs.trincoll.edu/~pgautam/positweb
#echo "Login Test"
#curl "$URL/api/login?password=logmein&imei=354957032494240"
echo 
echo "Registration Test"
curl "$URL/api/registerUser?email=prasannagautam@gmail.com&firstname=Prasanna&lastname=Gautam&password1=testpassword&password2=testpassword";
