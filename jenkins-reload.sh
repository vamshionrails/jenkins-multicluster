#curl -I --cookie $COOKIE_JAR $JENKINS_URL/reload -H $JENKINS_CRUMB -H "Content-Type:text/xml" -u $JENKINS_USER:$JENKINS_TOKEN 
#JENKINS  1
export JENKINS_URL="http://localhost:8090"
export JENKINS_USER="xxxxxx"
export JENKINS_TOKEN="xxxxxxxx"
export COOKIE_JAR="/tmp/cookies"
JENKINS_CRUMB=$(curl --silent --cookie-jar $COOKIE_JAR $JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)' -u $JENKINS_USER:$JENKINS_TOKEN)
echo $JENKINS_CRUMB
#curl -I --cookie $COOKIE_JAR $JENKINS_URL/reload -H $JENKINS_CRUMB -H "Content-Type:text/xml" -u $JENKINS_USER:$JENKINS_TOKEN -v
curl -s -X POST -I --cookie $COOKIE_JAR -H ${JENKINS_CRUMB} -u $JENKINS_USER:$JENKINS_TOKEN "http://localhost:8090/reload"

#JENKINS 2

export JENKINS_URL="http://localhost:9090"
export JENKINS_USER="xxxxxx"
export JENKINS_TOKEN="xxxxxx"
export COOKIE_JAR="/tmp/cookies"
JENKINS_CRUMB=$(curl --silent --cookie-jar $COOKIE_JAR $JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)' -u $JENKINS_USER:$JENKINS_TOKEN)
echo $JENKINS_CRUMB
#curl -s -X POST -H ${JENKINS_CRUMB} -u $JENKINS_USER:$JENKINS_TOKEN "http://localhost:9090/reload"
curl -s -X POST -I --cookie $COOKIE_JAR -H ${JENKINS_CRUMB} -u $JENKINS_USER:$JENKINS_TOKEN "http://localhost:9090/reload"
