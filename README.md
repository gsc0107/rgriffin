# rGriffin : R Gene Regulatory Interaction Formulator For Inquiring Networks

Boolean networks allow us to give a mechanistic explanation to how cell types emerge from regulatory networks. However, inferring the regulatory network and its functions is complex problem, as the available information is often incomplete. [`rGriffin`](https://github.com/mar-esther23/rgriffin) uses available biological information (regulatory interactions, cell types, mutants) codified as a set of restrictions and returns the [Boolean Networks](https://en.wikipedia.org/wiki/Boolean_network) that satisfy that restrictions. This Boolean networks can then be used to study the biological system.

The `rGriffin` package is an R connector to [`Griffin`](http://turing.iimas.unam.mx/griffin/) (Gene Regulatory Interaction Formulator For Inquiring Networks), a java library for inference and analysis of Boolean Network models. `Griffin` takes as inputs biologically meaningful constraints and turns them into a symbolic representation. Using a SAT engine, `Griffin` explores the Boolean Network search space, finding all satisfying assignments that are compatible with the specified constraints. The`rGriffin` package includes a number of functions to interact with the BoolNet package.



## Installation

rGriffin depends on Java and rJava.

First, make sure you have java installed, we recommend [Oracle JDK 8](https://docs.oracle.com/javase/8/docs/technotes/guides/install/install_overview.html).


Then install [rJava](https://cran.r-project.org/web/packages/rJava/index.html), this can be done from CRAN. While rJava should be authomatically instaled with rGriffin, the installation of rJava is succeptible to mistakes, so it is best to install it first.
	
```
> install.packages(Rjava)
```

Finally, install rgriffin from github using devtools

```
>devtools::install_github("mar-esther23/rgriffin")
```


## A small example

Let us suppose a cell, we know that this cell has three proteins called __a__, __b__ and __c__. We know that **a** activates **b** and that **b** and **c** inhibit each other.  We also suspect that **b** and **c** __may__ have positive self-regulatory loops. We can add this interactions to the table as “OPU” (optional, positive, unambiguous). This dataframe is the topology of the network.

Source | Target | Interaction
---|---|---
a | b | +
b | c | -
c | b | -
b | b | OPU
c | c | OPU

Suppose we also have some information of what cell types have been observed. For example, there is a cell type that expresses __b__, but not __a__ or __c__ and an other cell type that expresses __c__, but not __a__ or __b__. There might exist a third cell type that has not been fully characterized where we know that the cell expresses no __a__ or __c__ but we have NO information on __b__. This dataframe is the attractors of the network.

a | b | c
---|---|---
0 | 1 | 0
0 | 0 | 1
0 | * | 0

We can then use this information to create a query. `rGriffin` can include other types of information like transition between cell type, cycles, transitions between cell types or mutant cell types.

```
genes = c('a','b','c')
inter = data.frame(source=c('a','b','c',’b’,'c'), 
                  target=c('b'','c','b','b,'c'), 
                  type=c('+','-','-','OPU','OPU'),
                    stringsAsFactors = F )
q = create.gquery.graph(inter, genes)
attr = data.frame(a=c(0,'*',0), 
                 b=c(0,1,0), 
                 c=c(0,0,1),
                 stringsAsFactors = F )
q = add.gquery.attractors(q, attr)
```

Then we can use `Griffin` to find the networks that behave according with our biological information. 

```
nets = run.gquery(q)
nets
```

```
"targets,factors\na,false\nb,((((((!a&b)&!c)|((!a&b)&c))|((a&!b)&!c))|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n",
"targets,factors\na,false\nb,((((((!a&b)&!c)|((a&!b)&!c))|((a&!b)&c))|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n",
"targets,factors\na,false\nb,(((((!a&b)&!c)|((a&!b)&!c))|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n",
"targets,factors\na,false\nb,((((!a&b)&!c)|((a&!b)&!c))|((a&b)&!c))\nc,(!b&c)\n",
"targets,factors\na,false\nb,((((!a&b)&!c)|((a&b)&!c))|((a&b)&c))\nc,(!b&c)\n"
```

There are multiple options to integrate `BoolNet` and `rGriffin`. The function `get.net.topology()` can obtain the topology with interaction signs of a BoolNet network. The function `attractor2dataframe()` can be used to export a BoolNet attractor as a dataframe that `rGriffin` can use. The function `run.gquery()` includes the option `return=’BoolNet’`, that return the inferred networks as `BoolNet` networks.



## History

The development of [`Griffin`](http://turing.iimas.unam.mx/griffin/) began in <> to solve <>. During the next years `Griffin` continued to be developed by <> with comments from <>.

In January, 2017 we organized a course in [C3-UNAM](https://www.c3.unam.mx) to teach biologist how to use `Griffin`. We received two main comments: the input format was too complicated and it was uncomfortable to use the output with other packages. After some consideration we decided to create an `R` wrapper that could export and import `BoolNet` networks. We selected `BoolNet` as it has an good documentation and the package `BoolFilter` had been designed to work with it.

The development of `rGriffin` began during the [EOBM 2017](http://fejer.ucol.mx/biomate/) in [CUIB](https://portal.ucol.mx/cuib/). For the following year we continued developing `rGriffin` as our schedules allowed. There were multiple challenges during the development: defining user-friendly inputs, using `Rjava`, and structuring the package. In August 2018, we attended the [TIB2018-BCDW](http://congresos.nnb.unam.mx/TIB2018/r-bioconductor-developers-workshop-2018/) where we received valuable guidance from Martin Morgan and Benilton S Carvalho. It was during this workshop that the first version of `rGriffin` was finished.

We hope to continue developing `Griffin` and `rGriffin`. If you have ideas, suggestions or bugs, please contact us at [Github](https://github.com/mar-esther23/rgriffin).
