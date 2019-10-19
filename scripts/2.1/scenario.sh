#!/bin/bash

#Написать сценарий для добавления нового пользователя в систему с созданием его домашнего каталога, настройки окружения пользователя. 
#Имя, пароль и подтверждения пароля пользователя вводятся с клавиатуры при запуске сценария. 
#При попытке создания пользователя, который уже существует, сценарий должен завершаться с выводом в консоль кода завершения и сообщения об ошибке.
check_name() {
	local result=$(find /home -type d -name $1 | wc -l)
	if (( $result != 0 )); then
		echo "User with provided name already exists!"
		exit 1
	fi
}

is_password_empty() {
	if [[ -z "$1" ]]; then
		echo "Password can't be empty"
		exit 1
	fi
}

check_equality() {
	if [[ "$1" != "$2" ]]; then
		echo "Passwords aren't equal"
		exit 1
	fi
}


echo "This scenario is developed to create and config new user"
read -p "Please type new user username : " username
check_name $username

read -p "Please type new user password : " -s password
is_password_empty $password
echo ""

read -p "Please duplicate new user password : " -s duplicate_password
check_equality $password $duplicate_password
echo ""
#check if passwords are equal


