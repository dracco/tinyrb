# This is just a basic spec framework to test the kernel while I work running the parser.
# I'll try to make it compatible w/ mspec so I copy them when I'm finished.
# Some of it is ugly cause I don't have Exception rescue yet.

$__spec_failures = 0
$__spec_count = 0

def describe(name)
  puts name.to_s
  yield
  puts ""
end

def it(name)
  puts "  it " + name
  yield
end

def xit(name)
  puts "  ignoring: it " + name
end

def print_spec_summary!
  puts $__spec_count.to_s + " examples, " +
       $__spec_failures.to_s + " failures"
end

class SpecMatcher
  def initialize(object, negate)
    @object = object
    @negate = negate
  end
  
  def ==(other);  _match "==",  other, @object == other  end
  def >(other);   _match ">",   other, @object > other   end
  def <(other);   _match "<",   other, @object < other   end
  def !=(other);  _match "!=",  other, @object != other  end
  def ===(other); _match "===", other, @object === other end
  
  def _cond(cond)
    @negate ? !cond : cond
  end
  def _match(op, other, result)
    $__spec_count = $__spec_count + 1
    $__spec_failures = $__spec_failures + 1 unless _cond(result)
    puts "    " + @object.inspect + " " + (@negate ? "not " : "") + op + " " + other.inspect + ": " +
                  (_cond(result) ? "SUCCESS" : "FAIL")
  end
end

class Object
  def should
    SpecMatcher.new(self, false)
  end
  def should_not
    SpecMatcher.new(self, true)
  end
end