This scripts log temparature values to a mysql database and visualize the values trough a munin plugin.
The solution consists of 4 files:

- import script to import new temperature sensors in the database
- example textfile, here you define your sensors, so that they can importet by the import script
- log script polls the sensors and write the temperature values to the mysql db
- munin plugin uses the temperature values in the mysql db and draws nice graphs

Sensor hardware:
As sensor hardware is use arduino compatible stuff that is able to run the arduino webserver example like an 
arduino with ethernet shield or an esp8266. If you want to get an idea, you can visit my esp8266 repo: 
https://github.com/mkirbst/esp8266ds1820webserver
