I am making some acceptance tests for the LevenAls website, using plain text stories from [David Chelimsky](http://blog.davidchelimsky.net/articles/2007/10/25/plain-text-stories-part-iii) together with the Selenium runner from  Kerry Buckley (http://www.kerrybuckley.com/2007/11/07/driving-selenium-from-the-rspec-story-runner-rbehave/)

    Story: Selenium clicking a label

    As a developer
    I wanted to make acceptence tests
    So I installed Cucumber and Selenium

      Scenario: Writing clean tests
        When I wanted to make the stories as clean as possible
        And I wanted to click a rails generated radiobutton
        Then the story became ugly
        And it had lines like 'the user clicks a customer_gender_m button'

      Scenario: I made a step for labels, getting the text
        When I wanted to get rid of it
        And I couldn't find an easy answer
        And I spent the better part of my evening googling it
        Then I made a post on the Selenium forum
        And asked for advice

      Scenario: I found a solution myself
        When I was sitting in the train
        And I was trying all kinds of solutions
        Then I stumbled upon the solution
        And I was overjoyed
        And it was: $selenium.click("//label[text()='#{label}']")

So here is the entire step:

    When "the user clicks on a $element labelled $label" do |element, label|
      $selenium.click "//label[text()='#{label}']"
    end
