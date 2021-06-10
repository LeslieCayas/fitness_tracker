def run_sql(sql_query, params=[])
  connection = PG.connect(ENV['DATABASE_URL'] || {dbname: 'planets_app'})
    ## use working database or the database already specified (if found in local machine)
  connection.prepare("statement_name", sql_query)
  results = connection.exec_prepared("statement_name", params)
  connection.close

  return results
end
