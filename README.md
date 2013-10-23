# A Lineman JS Template using Thinner

This [Lineman](https://github.com/testdouble/lineman) template is crafted to work with [Thinner](https://github.com/pateketrueke/thinner).

It includes the following features:

  - Bower integration
  - Enables Jade templating
  - Process _literated_ CoffeeScript files
  - Adds Blanket and jasmine-async within Teste'm
  - Adds `config.yaml` and `vendor.yaml` for easy setup
  - Enables selective configuration per target with `lineman build -- target`

## Instructions

```
$ npm install -g volo
$ volo create my-app pateketrueke/lineman-template
  ...

$ cd my-app
$ lineman run
  ...
```

[![Build Status](https://travis-ci.org/pateketrueke/lineman-template.png)](https://travis-ci.org/pateketrueke/lineman-template)
