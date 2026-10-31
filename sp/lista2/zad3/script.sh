
echo "You've executed this bash script."

sleep 2

echo "Train incomming..."

sleep 2

if command -v sl>/dev/null
then 
    sl
else
    echo "Unfortunatley the train has been cancled."
fi

echo "Byeee"