library(showtext)

font_add_google('Pacifico', 'pacifico')
showtext_auto()

library(ggplot2)
library(hexSticker)

df <- data.frame(
  xstart = c(-1, -0.4, 0.08, 0.55),
  xend = c(-0.4, 0.08, 0.55, 1),
  color = c("#7288C4", "#b0cb04", "#fbc201", "#eb6353")
)

p <- ggplot(NULL, aes(x = 0, y = 0)) + 
  xlim(-1, 1) + 
  ylim(0, 5) +
  geom_rect(
    data = df,
    aes(
      NULL,
      NULL,
      xmin = xstart,
      xmax = xend,
      fill = I(color)
    ),
    ymin = 0,
    ymax = 4,
    size = 0.5
  ) +
  theme_void() +
  theme(legend.position = 'none')
p
# for windows
sticker(
  p,
  s_x = 1,
  s_y = 1.2,
  s_width = 1.9,
  s_height = 1,
  package = "DNH4",
  p_color = "#ffffff",
  p_family = "pacifico",
  p_size = 35,
  p_y = 1.1,
  filename = "man/figures/logo.png",
  h_fill = "#ffffff",
  h_color = "#ffffff",
  url = "forkonlp.github.io/DNH4",
  u_size = 5,
  u_color = "#c6c6c6"
)
