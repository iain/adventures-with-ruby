I installed the rails_rcov plugin to see the coverage like any good programmer ;-) But when I want
to know what all the tests combined produce in coverage, it just produced the coverage reports of
each individual test (units, functionals and integration) and replacing each with one another. I am
not a briliant googler, and when I couldn't find the answer in time, I decided to make my own rake
task for it. Here it is:

``` rake
namespace :test do
  desc "Run all tests at once through rcov."
  task :rcov do
    test_files = FileList['test/**/*_test.rb']
    output_dir = File.expand_path("./coverage/all/")
    command = "rcov -o \"#{output_dir}\" --rails --sort=coverage -T -x \"gems/*,rcov*,lib/*\" \"#{test_files.join('" "')}\""
    puts command
    puts `#{command}`
    puts "View all results at <file://#{output_dir}/index.html>"
  end
end
```

Now, it doesn't take any argument yet, but it works quite all right.
