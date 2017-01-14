### definerb

A proof-of-concept Ruby module loader inspired by the semantics of
the [amd api](https://github.com/amdjs/amdjs-api/wiki/AMD)!

### Why

One of Ruby's greatest weaknesses is that it lacks a good mechanism
for named imports and exports. When you `require` a ruby file, its
declarations (classes, modules, etc) get evaluated into your scope.
In contrast, the node.js commonjs module system allows developers
to explicitly declare module exports that consumers can access on
the loaded module object. Many prefer the explicit and isolated aspects
of js modules. This experiment strives to demonstrate a cleaner modules
abstraction for Ruby that maintains some interoperability with existing
practices in the Ruby standard library and community packages.

### Example (alpha syntax)

```rb
### foo.rb

$define.call do |import|
  def foo
    'foo'
  end
end

### test.rb

# load local modules defined with an amd-inspired syntax
foo = $import.call('./foo')

# compatible with external globals-style ruby modules
assert = $import.call('test/unit/assertions')['Test::Unit::Assertions']

assert.assert_equal(foo.foo(), 'foo')
```