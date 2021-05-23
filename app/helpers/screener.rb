
class Screener
    def init
        agent = Mechanize.new
        page = agent.get('https://screener.in/login') do |login_page|
            login_form = login_page.forms[1]
            login_form.username = 'thimmaiah@yahoo.com'
            login_form.password = 'mohith'

            dash = agent.submit(login_form, login_form.buttons.first)

            puts agent.cookie_jar.to_a

            details_page = agent.get('https://screener.in/company/VSTIND/')
            ratios = details_page.search(".container")

            puts agent.cookie_jar.to_a

            return ratios
        end
    end
end

