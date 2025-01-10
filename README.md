# Minideck Format

## Installing


```bash
quarto use template jtlandis/quarto-typst-minideck
```

This will install the format extension and create an example qmd file
that you can use as a starting place for your document.

## Using

This format uses the [`typst` minideck package](https://typst.app/universe/package/minideck/) allowing you to create slides by adding divs with the class `slide`.

```markdown

::: slide

## Slide 1

Some content

:::

```

This format also includes a [`typst` columns](https://github.com/jtlandis/typst-column) quarto filter that allows you to create columns in your slides. As well as a filter to allow the [`typst` pinit package](https://github.com/jtlandis/quarto-pinit)
