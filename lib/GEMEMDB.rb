# frozen_string_literal: true

require_relative "GEMEMDB/version"
require 'matrix'

module GEMEMDB
  class Error < StandardError; end
  class InvalidMatrix < RuntimeError; end

	class Tafya
    # Создание конечного автомата из регулярного выражения
		def reg_fm(s_param)
			s = s_param.delete(' ')
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

    # Создание уравнения из матрицы переходов конечного автомата
    def matrixToEquation(param, perem, matrix)
      # Создание уравнения из матрицы
      equation = Array.new(perem.count) {''}
      (0..perem.count-1).to_a.each do |i|
          (0..param.count-1).to_a.each do |j|
            if matrix[i,j] != '0' && matrix[i,j] != '-'
              if matrix[i,j].size > 1
                (0..matrix[i,j].size-1).to_a.each do |k|
                  equation[i] += param[j].to_s + matrix[i,j][k].chr.to_s + '+'
                end
              else
                equation[i] += param[j].to_s + matrix[i,j].to_s + '+'
              end
            end
          end
          equation[i].chop!
      end
      (0..perem.count-1).to_a.each do |i|
        if perem[i][1] == 'e'
          equation[i] += '+' + 'e'
        end
      end
      (0..perem.count-1).to_a.each do |i|
        (0..perem.count-1).to_a.each do |j|
          if (equation[i].include? perem[j][0] and i>j)
            throw InvalidMatrix
          end
        end
      end
      equationToSolution(perem, equation)
    end

    # Сортировка уравнения к виду (x1 = x1 + x2 + ... + xn, x2 = x2 + x1 + ... + xn, ... , xn = xn + x1 + x2 + ... + xn-1)
    private def sortEquation(perem, equation)
      # Сортировка уравнения
      newEquation = Array.new(perem.count) {''}
      z = Hash.new()
      (1..perem.count).to_a.each do |j|
        z[perem[j-1][0]] = (j+1).to_s
      end
      (0..perem.count-1).to_a.each do |i|
        (1..perem.count).to_a.each do |k|
          z[perem[k-1][0]] = (z[perem[k-1][0]].to_i - 1).to_s
          if z[perem[k-1][0]] == '0'
            z[perem[k-1][0]] = perem.count.to_s
          end
        end
        (0..perem.count-1).to_a.each do |k|
          equation[i].gsub!(perem[k][0], 'X' + z[perem[k][0]])
        end

        help = equation[i].split('+')
        help.sort_by! {|a| a[-1]}
        (0..perem.count-1).to_a.each do |k|
          help.each {|a| a.gsub!('X' + z[perem[k][0]], perem[k][0])}
        end

        (0..help.count-1).to_a.each do |j|
          if help[j].match('\d*[A-Z]\d*') != nil
            newEquation[i] += help[j] + '+'
          end
        end

        (0..help.count-1).to_a.each do |j|
          if help[j].match('^[^A-Z]*$') != nil
            newEquation[i] += help[j] + '+'
          end
        end
        newEquation[i].chop!
      end
      newEquation
    end

    # Поиск решения каждого из уравнений
    private def equationToPredSolution(perem, equation)
      h = Hash.new()
      # Приведение к решению уравнения
      (0..perem.count-1).to_a.each do |i|
        h[perem[i][0]] = equation[i]
        if h[perem[i][0]].include? perem[i][0]
          help = h[perem[i][0]].split('+')
          p = ''
          newStr = ''
          (0..help.count-1).to_a.each do |j|
            if help[j].include? perem[i][0]
              p += help[j].chop + '+'
            end
          end
          if p.size == 2
            newStr += p.chop + '*'
          else
            newStr += '(' + p.chop + ')*'
          end
          p = ''
          (0..help.count-1).to_a.each do |j|
            if !help[j].include? perem[i][0]
              p += help[j]+ '+'
            end
          end
          p.chop!
          if !p.include? '+'
            newStr += p
          else
            newStr += '(' + p + ')'
          end
          h[perem[i][0]] = newStr
          h[perem[i][0]].gsub!('+)', ')')
          h[perem[i][0]].gsub!('()', '')
          h[perem[i][0]].gsub!('(+', '(')
          h[perem[i][0]].gsub!('(e)', '')
          h[perem[i][0]].gsub!('*e', '*')
          h[perem[i][0]].gsub!('(\d)', '\d')
          # h[perem[i][0]].gsub!('(())', '()') # замена 2 скобок на одну
          # TODO Сделать удаление лишних скобок
        end
      end
      h
    end

    # Приведение отдельной строки к решению
    private def stringToPredSolution(perem, str)
      # Приведение к решению уравнения
      if str.include? perem
        help = str.split('+')
        p = ''
        newStr = ''
        (0..help.count-1).to_a.each do |j|
          if help[j].include? perem
            p += help[j].chop + '+'
          end
        end
        if p.size == 2
          newStr += p.chop + '*'
        else
          newStr += '(' + p.chop + ')*'
        end
        p = ''
        (0..help.count-1).to_a.each do |j|
          if !help[j].include? perem
            p += help[j]+ '+'
          end
        end
        p.chop!
        if !p.include? '+'
          newStr += p
        else
          newStr += '(' + p + ')'
        end
        newStr.gsub!('+)', ')')
        newStr.gsub!('()', '')
        newStr.gsub!('(+', '(')
        newStr.gsub!('(e)', '')
        newStr.gsub!('*e', '*')
        # h[perem[i][0]].gsub!('(())', '()') # замена 2 скобок на одну
        # TODO Сделать удаление лишних скобок
      end
      newStr
    end

    # Решение уравнения(поиск регулярного выражения)
    def equationToSolution(perem, equation)
      # Решение уравнения
      equation = sortEquation(perem, equation)
      h = equationToPredSolution(perem, equation)
      # Подстановка решений
      (0..perem.count-1).to_a.reverse.each do |i|
        (0..perem.count-1).to_a.each do |j|
          if equation[i].include? perem[j][0] and perem[j][0] != perem[i][0]
            if equation[j][-1] != ')' and equation[j][-1] != '*'
              equation[i].gsub!(perem[j][0], '(' + h[perem[j][0]] + ')')
            else
              equation[i].gsub!(perem[j][0], h[perem[j][0]])
            end
          end
        end
        if equation[i].include? perem[i][0]
          equation[i] = stringToPredSolution(perem[i][0], equation[i])
          h[perem[i][0]] = equation[i]
        end
      end
      h[perem[0][0]]
    end

	end
end
