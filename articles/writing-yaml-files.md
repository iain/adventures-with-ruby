A short one for today: How do I write [YAML](http://en.wikipedia.org/wiki/YAML) files?

Well, to get the prettiest results, I do something like this:

``` ruby
def write(filename, hash)
  File.open(filename, "w") do |f|
    f.write(yaml(hash))
  end
end

def yaml(hash)
  method = hash.respond_to?(:ya2yaml) ? :ya2yaml : :to_yaml
  string = hash.deep_stringify_keys.send(method)
  string.gsub("!ruby/symbol ", ":").sub("---","").split("\n").map(&:rstrip).join("\n").strip
end
```


I use the gem [ya2yaml](http://rubyforge.org/projects/ya2yaml/) to create YAML, because the default
Hash#to_yaml doesn't work well with UTF-8. If you have it installed and loaded, it uses that.

Then I turn all keys into strings with the method `deep_stringify_keys`, so the keys don't get
formatted like the symbols they are. I remove some random junk and strip whitespace.

To add the `deep_stringify_keys`, open the Hash class:

``` ruby
class Hash
  def deep_stringify_keys
    new_hash = {}
    self.each do |key, value|
      new_hash.merge!(key.to_s => (value.is_a?(Hash) ? value.deep_stringify_keys : value)))
    end
  end
end
```

Here are the specs for this:

``` ruby
class Hash
  def deep_stringify_keys
    new_hash = {}
    self.each do |key, value|
      new_hash.merge!(key.to_s => (value.is_a?(Hash) ? value.deep_stringify_keys : value)))
    end
  end
end
```
