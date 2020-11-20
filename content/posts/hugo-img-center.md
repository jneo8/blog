---
title: "Hugo img centering"
date: 2020-08-19T17:28:22+08:00
tags: ["hugo"]
---

How to make hugo image center in Markdown.

<!--more-->


```css
img[src$='#center']
{
    display: block;
    margin: 0.7rem auto; /* you can replace the vertical '0.7rem' by
                            whatever floats your boat, but keep the
                            horizontal 'auto' for this to work */
    /* whatever else styles you fancy here */
}

img[src$='#floatleft']
{
    float:left;
    margin: 0.7rem;      /* this margin is totally up to you */
    /* whatever else styles you fancy here */
}

img[src$='#floatright']
{
    float:right;
    margin: 0.7rem;      /* this margin is totally up to you */
    /* whatever else styles you fancy here */
}
```


then, inside your Markdown content, pull in the images as follows:

```markdown
![your_img_alt_text](/img/your_img.png#center)
![your_img_alt_text](/img/your_img.png#floatleft)
![your_img_alt_text](/img/your_img.png#floatright)
```

## Source

- https://gist.github.com/mostafa-asg/bd6700f4475f68730b4ea3bf12afe7ee
- http://www.ebadf.net/2016/10/19/centering-images-in-hugo/
