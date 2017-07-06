require 'mechanize'
require 'nokogiri'

LOGIN = 'test@example.com'
PASSWORD = 'secret'
URL = 'https://staqresults.herokuapp.com'

class Quiz
	def initialize
		@mechanize = Mechanize.new
		@page = @mechanize.get(URL)
	end

	def run
		@authorized_page = get_authorized_page
		get_tests_results_hash
	end

	def get_authorized_page
		login_form = @page.forms[0]
		login_form.fields[0].value = LOGIN
		login_form.fields[1].value = PASSWORD
		# submits login form and returns authorized page
		@mechanize.submit(login_form)
	end

	def get_tests_results_hash
		results = {}
		table = @authorized_page.at('tbody')
		table.search('tr').each do |tr|

			date = tr.search('.date').text
			tests = tr.search('td')[1].text
			passes = tr.search('td')[2].text
			failures = tr.search('td')[3].text
			pending = tr.search('td')[4].text
			coverage = tr.search('td')[5].text
			test = { tests: tests, passes: passes, failures: failures, 
				pending: pending, coverage: coverage}
			results[date] = test
		end
		results
	end
 
end
