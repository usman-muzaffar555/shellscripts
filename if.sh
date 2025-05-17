# if <,> are being used in if statement, then use double brackts instead of single brackets
# if pattern matches required like "var" == "var2"* , then use double brackets

# 1. pattern matching
var="This is test message."
var2="This is"

if [[ "$var" == "$var2"* ]] ; then
  echo "This is correct"
fi

# 2. regex matching
email="test@example.com"

if [[ $email =~ ^[a-z]+@[a-z]+\.[a-z]+$ ]]; then
    echo "Valid email"
fi

# 3. no quotes neede
if [[ $file == "test" ]]; then 
    echo "File is test"
fi

abc="10:10"
def=10
for itr in `eval echo {1..10}`
do
if [ $abc == 10* ]
then
echo $def
fi
done

string1="good"
string2="good2"
if [ $string1 = $string2 ]
then
echo "equal"
else
echo "not equal"
fi
a=4
b=5
if [ a > b ] && echo "ab"

