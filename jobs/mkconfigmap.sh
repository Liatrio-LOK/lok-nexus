#!/usr/bin/env bash

echo "enter nexus username:"

read uname

echo "enter nexus password:"

read -s pword

echo "enter nexus email:"

read email

echo "enter nexus first name:"

read fname

echo "enter nexus last name:"

read lname


kubectl create configmap nexus-credentials \
  --from-literal=user.name=$uname\
  --from-literal=user.password=$pword\
  --from-literal=user.email=$email\
  --from-literal=user.fname=$fname\
  --from-literal=user.lname=$lname
