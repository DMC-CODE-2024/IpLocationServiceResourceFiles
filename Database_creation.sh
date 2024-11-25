source ~/.bash_profile
source $commonConfigurationFile
dbDecryptPassword=$(java -jar  ${pass_dypt} spring.datasource.password)

mysql  -h$dbIp -P$dbPort -u$dbUsername -p${dbDecryptPassword} $appdbName <<EOFMYSQL

CREATE TABLE if not exists ip_location_country_ipv4 (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  start_ip_number int unsigned DEFAULT '0',
  end_ip_number int unsigned DEFAULT '0',
  country_code char(2) DEFAULT '',
  country_name varchar(64) DEFAULT '',
  data_source varchar(10) DEFAULT '',
  PRIMARY KEY (id)
);

CREATE TABLE if not exists ip_location_country_ipv6 (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  modified_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  start_ip_number decimal(39,0) unsigned DEFAULT '0',
  end_ip_number decimal(39,0) unsigned DEFAULT '0',
  country_code char(2) DEFAULT '',
  country_name varchar(64) DEFAULT '',
  data_source varchar(10) DEFAULT '',
  PRIMARY KEY (id)
);

insert ignore into   sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values ( 'The key used for api call to ip location database to query country for an IP.', 'ipCountryApiKey', '63E2F05CC085E319664B99D6AB5D4426', 'Ip location' , 0,1,'','','');
insert ignore  into  sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values ( 'The url used for api call to ip location database to query country for an IP.', 'ipCountryApiUrl', 'https://api.ip2location.io/?key=<key>&ip=<ip>&format=json', 'Ip location', 0,1,'','','' );

insert ignore into  sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values('The URL used to download IP location dump.', 'ipLocationDumpFileURL', 'https://www.ip2location.com/download?token=<token>\\&file=<code>', 'Ip Location' , 0,1,'','','' );
insert ignore  into sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values( 'The code used to download ipv4 ip location dump.', 'ipLocationCodeipv4', 'DB1', 'Ip Location' , 0,1,'','','' );
insert ignore  into  sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values( 'The code used to download ipv6 ip location dump', 'ipLocationCodeipv6', 'DB1IPV6', 'Ip Location' , 0,1,'','','');
insert ignore into  sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values( 'The tag is used to store the last processed date for ip location processor for ip-type ipv6.', 'last_process_date_ip_location_ipv6', '', 'Ip Location', 0,1,'','','');
insert ignore into  sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values( 'The tag is used to store the last processed date for ip location processor for ip-type ipv4.', 'last_process_date_ip_location_ipv4', '', 'Ip Location' , 0,1,'','','');
insert ignore into  sys_param (description, tag, value, feature_name,type,active,remark,user_type,modified_by) values( 'The tag is used to store the token for downloading the ip location dump files.', 'ipLocationURLKey', 'RBq0UtKeLBmZrQeaLwBLjTzhGTVtqqzvjp7idqG4UYNMGgKcSCeNCwvIFHUnjP4d', 'Ip Location', 0,1,'','','');

insert ignore into   cfg_feature_alert (alert_id, description, feature) values ('alert2142', 'The DB configuration is missing.', 'Ip Location');
insert ignore into  cfg_feature_alert (alert_id, description, feature) values ('alert2143', 'The values for either IP Location Processor dump file url or IP Location Processor url key is missing in database <e>', 'Ip Location');
insert ignoreinto   cfg_feature_alert (alert_id, description, feature) values ('alert2144', 'The file downloading failed for  <e>.', 'Ip Location');
insert ignore into   cfg_feature_alert (alert_id, description, feature) values ('alert2145', 'The file downloading was incomplete for <e>.', 'Ip Location');
insert ignore into   cfg_feature_alert (alert_id, description, feature) values ('alert2146', 'The dump file is not found for <e>.', 'Ip Location');
insert ignore into   cfg_feature_alert (alert_id, description, feature) values ('alert2147', 'The java process did not complete successfully for file <e> for <process_name>.', 'Ip Location');
insert ignore into   cfg_feature_alert (alert_id, description, feature) values ('alert2148', 'The previous processed file <process_name> does not exists on the server for <e>.', 'Ip Location');


EOFMYSQL
