echo 'convert start'
cd `dirname $0`
cd ../
coffee -c -o output coffee/shaved_ice.coffee
cat output/shaved_ice.js > output/shaved_ice.jsx
