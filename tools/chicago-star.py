#!/usr/bin/env python3
"""Generate the Chicago-star mask paths used for the URL-bar bookmark star (#48).

The shape is derived, not copied: design.chicago.gov specifies six points with 30° tips.
For a six-point star, a 30° tip fixes the inner/outer radius ratio at
sin(15°) / sin(45°) ≈ 0.366. Each tip apex is rounded (a small-icon optical correction):
the radius is 0.5 CSS px at the reference box size, expressed in viewBox units so it scales
with the star. The hollow (not-bookmarked) star is a cut-out band: the rounded outer star
minus an edge-offset inner star, filled evenodd. A stroke's miter spikes at 30° overran the box.

Usage:  python3 tools/chicago-star.py      # prints the FILLED and HOLLOW path data
"""
from __future__ import annotations

import math

VIEWBOX = 24.0            # SVG viewBox size (units)
CENTER = VIEWBOX / 2
OUTER_R = 11.0            # outer radius (units) — 1 unit clear of the box edge
POINTS = 6
TIP_DEG = 30.0            # design.chicago.gov: six points at 30°
REF_BOX_PX = 22.0         # --tf-star-size the tip rounding is tuned at (chrome/dials.css)
TIP_ROUND_PX = 0.5        # apex radius in CSS px at REF_BOX_PX
BAND_UNITS = 1.4          # hollow-star band width (units)

Point = tuple[float, float]


def star_points() -> list[Point]:
    """Vertices of the star, outer tip first (pointing up), alternating outer/inner."""
    half = math.radians(TIP_DEG / 2)
    inner_r = OUTER_R * math.sin(half) / math.sin(half + math.pi / POINTS)
    step = 360.0 / (2 * POINTS)
    return [
        (CENTER + r * math.cos(math.radians(-90 + k * step)),
         CENTER + r * math.sin(math.radians(-90 + k * step)))
        for k in range(2 * POINTS)
        for r in [OUTER_R if k % 2 == 0 else inner_r]
    ]


def _toward(a: Point, b: Point, length: float) -> Point:
    """The point `length` units from a toward b."""
    d = math.dist(a, b)
    return (a[0] + (b[0] - a[0]) * length / d, a[1] + (b[1] - a[1]) * length / d)


def _fmt(p: Point) -> str:
    return f"{p[0]:.2f} {p[1]:.2f}"


def rounded_path(points: list[Point]) -> str:
    """Path through the vertices with each OUTER apex rounded (quadratic, control at apex)."""
    radius = TIP_ROUND_PX * VIEWBOX / REF_BOX_PX
    tangent = radius / math.tan(math.radians(TIP_DEG / 2))
    parts: list[str] = []
    for i, p in enumerate(points):
        if i % 2:  # inner vertex: stays sharp
            parts.append(f"L{_fmt(p)}")
            continue
        a = _toward(p, points[i - 1], tangent)
        b = _toward(p, points[(i + 1) % len(points)], tangent)
        parts.append(f"{'M' if i == 0 else 'L'}{_fmt(a)}Q{_fmt(p)} {_fmt(b)}")
    return "".join(parts) + "Z"


def sharp_path(points: list[Point]) -> str:
    return "M" + "L".join(_fmt(p) for p in points) + "Z"


def inset(points: list[Point], width: float) -> list[Point]:
    """Offset every edge inward by `width` and intersect neighbours (the band's inner edge)."""
    cx = sum(p[0] for p in points) / len(points)
    cy = sum(p[1] for p in points) / len(points)
    lines: list[tuple[Point, Point]] = []
    for i, (x1, y1) in enumerate(points):
        x2, y2 = points[(i + 1) % len(points)]
        dx, dy = x2 - x1, y2 - y1
        nx, ny = -dy / math.hypot(dx, dy), dx / math.hypot(dx, dy)
        if (cx - (x1 + x2) / 2) * nx + (cy - (y1 + y2) / 2) * ny < 0:
            nx, ny = -nx, -ny
        lines.append(((x1 + nx * width, y1 + ny * width), (dx, dy)))
    out: list[Point] = []
    for i in range(len(lines)):
        (p, d), (q, e) = lines[i - 1], lines[i]
        t = ((q[0] - p[0]) * e[1] - (q[1] - p[1]) * e[0]) / (d[0] * e[1] - d[1] * e[0])
        out.append((p[0] + t * d[0], p[1] + t * d[1]))
    return out


def main() -> None:
    pts = star_points()
    print("FILLED:", rounded_path(pts))
    print("HOLLOW:", rounded_path(pts) + sharp_path(inset(pts, BAND_UNITS)))


if __name__ == "__main__":
    main()
