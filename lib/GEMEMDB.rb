# frozen_string_literal: true

require_relative "GEMEMDB/version"

module GEMEMDB
  class Error < StandardError; end
  def reg_fm(s)
	  s.delete!(' ')
	  eps = "Eps"
	  k = 0
	  tec = 0
	  h = 1
	  m = []
	  m1 = [[0], []]

	  for i in 0...s.length
		  if s[i] == '('
			  if m[tec].nil?
				  m[tec] = []
			  end
			  m[tec].push(Hash[eps => k + 1])
			  m1[h].push(k + 1)
			  k += 1
			  tec = k
			  h += 1
			  m1[h] = []
			  next
		  end
		  if s[i] == ')'
			  m1[h].push(tec)
			  if s[i + 1] == '*'
				  tec = m1[h - 1][-1]
			  else
				  tec = k + 1
				  k += 1
			  end
			  m1[h].each { |x|
					  if m[x].nil?
						  m[x] = []
					  end
					  m[x].push(Hash[eps => tec])
			  }
			  m1[h].clear
			  m1[h - 1].delete_at(-1)
			  h -= 1
			  next
		  end
		  if s[i] == '+'
			  m1[h].push(tec)
			  tec = m1[h - 1][-1]
		  elsif s[i] == '*'
			  if s[i - 1] != ')'
				  if m[tec].nil?
					  m[tec] = []
				  end
				  m[tec].push(Hash[s[i - 1] => tec])
			  end
		  else
			  if s[i + 1] != '*'
				  if m[tec].nil?
					  m[tec] = []
				  end
				  m[tec].push(Hash[s[i] => k + 1])
				  k += 1
				  tec = k
			  end
		  end
	  end

	  if !m1[h].empty?
		  m1[h].push(k)
		  k += 1
		  m1[h].each { |x|
				  if m[x].nil?
					  m[x] = []
				  end
				  m[x].push(Hash[eps => k])
		  }
		  tec = k
	  end

	  return m
  end
end
