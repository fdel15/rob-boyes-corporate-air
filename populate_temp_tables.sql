  select	column_name + ' ' +
			    data_type + isnull('(' + cast(character_maximum_length as varchar) + ')', '')
  
  from INFORMATION_SCHEMA.columns where table_name = { TABLE_NAME }
