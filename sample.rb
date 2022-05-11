require 'pg'

def pick_data
	conn = PG.connect(dbname: 'memos')
  result = conn.exec("SELECT * FROM memos WHERE id = 1")
end

def create_memo(title, content)
	conn = PG.connect(dbname: 'memos')
	conn.exec("INSERT INTO memos (title, content) VALUES('#{title}', '#{content}')")
end

@memo_info = pick_data
@memo_info.each do |tuple|
	puts tuple['id']
end