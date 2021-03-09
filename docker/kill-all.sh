#Stores results of $() command and passes as variable to next command

for i in $(docker ps -qa)
do
	docker rm -f $i
done
