local function QueryTable(Table,Query)
	local tfind = table.find(table, Query);
	if(tfind)then
		return Table[tfind], tfind;
	end;
	local dictionarySearch = Table[Query];
	if(dictionarySearch)then
		return dictionarySearch;
	end;
end;

return function(ToQuery,Query)
	if(typeof(ToQuery)=="table")then
		return QueryTable(ToQuery,Query)
	end
end
