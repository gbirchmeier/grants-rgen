# grants-rgen
**custom rails generators for my personal workflow**

Given this input file:

* [demo/rgenspec/thinger](thinger.yaml)

...it will output [these files](/demo/output/):

* regular Rails model with validations and `belongs_to` associations
* RSpec file with attribute validations (using shoulda-matchers)
* FactoryBot factory with decent defaults (even sequences!)
* ActiveAdmin config for the model with a basic index/view/form implemented,
  and some commented-out options you might want to use

Also, it will print out the migration-generation command for you to use.

## Tell me more

I got tired of writing the same boilerplate files every time I
added a new model to my project.
(Yeah, I know, Rails has a model generator, but I don't love it.)

It's all pretty formulaic, and
looking up syntax for uncommon cases is annoying.
This junk can be generated, so it *should* be generated!

Instead of specifying the attributes & associations via clunky command line,
you put them in a yaml file that `rgen` reads.  This is great, because often I
mess up once or twice before getting it right; I can just edit
the yaml file and re-run the generator.

## How do I use it?

It's completely standalone.  It doesn't care about your actual Rails app.
It just reads an input and spits out files.

1. Clone or download the repo

2. Make sure you have Rails gem installed, which you probably do. (RGen uses ActiveSupport::Inflector)

3. **App Configuration**

    When RGen runs, it looks for a config file `rgen.config.yaml` **(this exact file name)**
    in the same directory as the model's yaml file.
    That config file specifies which generators to run, and the output directories for the generated
    file types.
    
    All paths in this config that don't start with "/" are relative to the config file itself.
    
    Have a look at [demo/rgenspec/rgen.config.yaml](demo/rgenspec/rgen.config.yaml).

4. **Model Configuration**

    Specify the attributes and associations for the model you want to generate.
    
    The [demo file](demo/rgenspec/thinger.yaml) has comments that document it pretty well.

5. **Run the Generator**
    
    `grants-rgen$ ruby -I lib/ rgen.rb demo/rgenspec/thinger.yaml`

## FAQ

**Q: Can it generate controllers or views?**

No.  I don't use generators for those, so it's not really part of my workflow.

**Q: Why isn't this a gem?**

Not sure if anyone else would want it.  Could happen.

**Q: Why didn't you extend or implement a proper Rails generator?**

I didn't feel like learning how.
It was faster to just do this.

**Q: Why doesn't it generate minitest files?**

Because RSpec is waaaaay better.

## Bugs/Questions?

I dunno, make a Github issue I guess.  Or tweet me or something.
