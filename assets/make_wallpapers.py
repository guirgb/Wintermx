#!/usr/bin/env python3
"""Gera os wallpapers originais do WinTerm OS (azul com feixes de luz)
e o icone do menu Iniciar (4 blocos). Requer Pillow."""
import math, os, random
from PIL import Image, ImageDraw, ImageFilter, ImageChops

OUT = os.path.dirname(os.path.abspath(__file__))
W, H = 2560, 1440


def gradient(w, h, top, bottom):
    img = Image.new("RGB", (w, h))
    px = img.load()
    for y in range(h):
        t = y / (h - 1)
        c = tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
        for x in range(w):
            px[x, y] = c
    return img


def beams(base, color, origin, angles, widths, alpha):
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    ox, oy = origin
    L = max(base.size) * 2
    for a, wd in zip(angles, widths):
        r = math.radians(a)
        r1, r2 = r - math.radians(wd), r + math.radians(wd)
        pts = [(ox, oy),
               (ox + L * math.cos(r1), oy + L * math.sin(r1)),
               (ox + L * math.cos(r2), oy + L * math.sin(r2))]
        d.polygon(pts, fill=color + (alpha,))
    layer = layer.filter(ImageFilter.GaussianBlur(40))
    base = base.convert("RGBA")
    return Image.alpha_composite(base, layer).convert("RGB")


def glow(base, center, radius, color, strength):
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = center
    d.ellipse([cx - radius, cy - radius, cx + radius, cy + radius],
              fill=color + (strength,))
    layer = layer.filter(ImageFilter.GaussianBlur(radius // 2))
    return Image.alpha_composite(base.convert("RGBA"), layer).convert("RGB")


def hero():
    img = gradient(W, H, (4, 18, 52), (6, 66, 150))
    img = glow(img, (int(W * .72), int(H * .45)), 520, (20, 140, 255), 150)
    img = beams(img, (90, 190, 255), (int(W * .78), int(H * .5)),
                [190, 205, 220, 235, 160, 175], [3, 5, 2, 4, 3, 2], 70)
    img = beams(img, (200, 235, 255), (int(W * .78), int(H * .5)),
                [198, 212, 228], [1.2, 1.6, 1.0], 90)
    img = glow(img, (int(W * .78), int(H * .5)), 160, (210, 240, 255), 200)
    # leve granulado
    random.seed(7)
    noise = Image.effect_noise((W, H), 12).convert("RGB")
    # soft-light simples: mistura 4% de ruido sem alterar o brilho medio
    img = Image.blend(img, noise, 0.04)
    return img


def dark():
    img = gradient(W, H, (8, 8, 16), (26, 22, 60))
    img = glow(img, (int(W * .3), int(H * .6)), 600, (110, 60, 220), 120)
    img = glow(img, (int(W * .75), int(H * .3)), 480, (30, 120, 230), 110)
    return img


def aurora():
    img = gradient(W, H, (6, 30, 40), (10, 90, 90))
    img = glow(img, (int(W * .25), int(H * .7)), 620, (30, 200, 150), 130)
    img = glow(img, (int(W * .8), int(H * .35)), 520, (40, 140, 230), 120)
    img = beams(img, (120, 255, 210), (int(W * .1), int(H * 1.1)),
                [-50, -40, -30], [4, 3, 5], 55)
    return img


def start_icon(size=256):
    """Marca propria do WinTerm: 4 blocos arredondados em ciano."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    g = size // 16
    s = (size - 3 * g) // 2
    x0 = g
    r = size // 20
    for i in range(2):
        for j in range(2):
            x = x0 + j * (s + g)
            y = x0 + i * (s + g)
            d.rounded_rectangle([x, y, x + s, y + s], r, fill=(255, 255, 255, 255))
    return img.resize((48, 48), Image.LANCZOS)


if __name__ == "__main__":
    hero().save(os.path.join(OUT, "wallpaper-hero.png"))
    dark().save(os.path.join(OUT, "wallpaper-dark.png"))
    aurora().save(os.path.join(OUT, "wallpaper-aurora.png"))
    start_icon().save(os.path.join(OUT, "winterm-start.png"))
    print("Wallpapers gerados em", OUT)
