# language-handlebars package

Originally a [conversion](http://atom.io/docs/v0.60.0/converting-a-text-mate-bundle) of
[drnic's handlebars.tmbundle](https://github.com/drnic/Handlebars.tmbundle) for
the Atom editor

## Snippets

The package comes with some built-in snippets to help you work more quickly in Handlebars.
Feel free to submit issues or pull requests with suggestions for more

### Generic Snippets

#### bindAttr: `ba`

```handlebars
{{bindAttr ${1:class}=${2:"${3:isSelected}"}}}
```

#### checkbox: `chb`

```handlebars
{{view SC.Checkbox title="Title" class="class"
  valueBinding="App.controller.property"}}
```
#### collection: `coll`

```handlebars
{{#collection SC.TemplateCollectionView contentBinding="App.arrayListController"}}

{{/collection}}
```

#### content.field: `c`

```handlebars
{{content.${1:field}}}
```

#### if...end: `if`

```handlebars
{{#if condition}}

{{/if}}
```

#### if...else...end: `ife`

```handlebars
{{#if condition}}

{{else}}

{{/if}}
```

#### unless: `unl`

```handlebars
{{#unless condition}}

{{/unless}}
```

#### view: `view`

```handlebars
{{#view SC.TemplateView}}

{{/view}}
```

### Ember Snippets

I've also added some snippets that are particularly helpful for people
working with Ember.JS

#### ember-action: `ema`

```handlebars
{{action 'name'}}
```
