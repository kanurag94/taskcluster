set -e
set -x
npm run compile
mocha --compilers js:babel/register test/loader_tests.js