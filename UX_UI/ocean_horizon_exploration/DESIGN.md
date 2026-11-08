---
name: Ocean Horizon Exploration
colors:
  surface: '#f9f9ff'
  surface-dim: '#d1daf4'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f3ff'
  surface-container: '#e9edff'
  surface-container-high: '#e1e8ff'
  surface-container-highest: '#d9e2fc'
  on-surface: '#121b2e'
  on-surface-variant: '#3c494d'
  inverse-surface: '#273044'
  inverse-on-surface: '#edf0ff'
  outline: '#6c797d'
  outline-variant: '#bbc9cd'
  surface-tint: '#006879'
  primary: '#006879'
  on-primary: '#ffffff'
  primary-container: '#00c7e6'
  on-primary-container: '#004f5c'
  inverse-primary: '#35d8f8'
  secondary: '#0050cc'
  on-secondary: '#ffffff'
  secondary-container: '#0266ff'
  on-secondary-container: '#f9f7ff'
  tertiary: '#994700'
  on-tertiary: '#ffffff'
  tertiary-container: '#ff9e60'
  on-tertiary-container: '#753500'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#a9edff'
  primary-fixed-dim: '#35d8f8'
  on-primary-fixed: '#001f26'
  on-primary-fixed-variant: '#004e5c'
  secondary-fixed: '#dae1ff'
  secondary-fixed-dim: '#b3c5ff'
  on-secondary-fixed: '#001849'
  on-secondary-fixed-variant: '#003fa4'
  tertiary-fixed: '#ffdbc8'
  tertiary-fixed-dim: '#ffb68b'
  on-tertiary-fixed: '#321200'
  on-tertiary-fixed-variant: '#753400'
  background: '#f9f9ff'
  on-background: '#121b2e'
  surface-variant: '#d9e2fc'
typography:
  display-lg:
    fontFamily: Outfit
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Outfit
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Outfit
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Outfit
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: '0'
  headline-md:
    fontFamily: Outfit
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: '0'
  headline-sm:
    fontFamily: Outfit
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: '0'
  body-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Be Vietnam Pro
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.04em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-mobile: 1rem
  margin: 2rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

This design system embodies the invigorating spirit of modern coastal travel: open skies, clear turquoise lagoons, and seamless digital journey curation. The brand personality is welcoming, energetic, and immaculately organized—giving travelers immediate clarity, confidence, and excitement when planning their next escape.

Drawing from modern contemporary travel design, the interface balances refreshing, high-clarity minimalism with fluid, welcoming contours. Instead of cluttered banners or overwhelming gradients, it uses crisp, light-bathed layouts (#F7F9FC, #FFFFFF), tactile pill-shaped interactive anchors, and selective accents of electric ocean cyan (#00C7E6) balanced against structured royal ocean tones. The resulting aesthetic feels breezy, refined, and distinctly trustworthy.

## Colors

The color palette captures sunlit horizons and open waters. The seed cyan (`#00C7E6`) acts as an energizing visual beacon for interactive highlights, badges, and focus triggers, paired in harmony with deep ocean blue (`#0066FF`) for authoritative structural actions and navigation anchors. 

- **Primary Accent (`#00C7E6`):** Lagoon Cyan, applied to discovery tags, interactive highlights, search filters, and active tab indicators.
- **Secondary Foundation (`#0066FF`):** Deep Ocean Blue, grounding key conversion buttons, navigation bars, and primary CTAs.
- **Tertiary Accent (`#FF7A00`):** Sunset Amber, reserved strictly for price promotions, special discounts, and rating stars.
- **Surfaces & Grounds:** Clean canvas background in `#F7F9FC`, stacked against pristine white `#FFFFFF` cards and panels with whisper-thin structural borders (`#E5EAF2`).
- **Typography Contrast:** Direct readability is ensured via Primary Ink (`#172033`) for high-contrast headlines and Secondary Slate (`#667085`) for secondary tour itineraries, metadata, and captions.

## Typography

Typography establishes an effortless balance between modern geometric discovery and Vietnamese/multilingual reading comfort.

- **Headlines (`Outfit`):** Characterized by open, geometric forms and human warmth. It establishes an energetic editorial presence across tour destinations, promotional banners, and package headers.
- **Body & Labels (`Be Vietnam Pro`):** Tailored specifically for flawless diacritics, immaculate screen legibility at dense itinerary layouts, and frictionless form completion.
- **Hierarchical Discipline:** Large numerals for prices and durations adopt `Outfit` Semi-Bold for instant scanning, while supporting tour metadata, departure schedules, and terms utilize `Be Vietnam Pro` in regular and medium weights.

## Layout & Spacing

The layout is built upon an adaptive 12-column responsive fluid grid with generous, breathable margins to preserve a bright, open horizon feel.

- **Desktop (1200px+):** 12 columns with `1.5rem` (24px) gutters and `2rem` (32px) minimum exterior margin. Maximum container width caps at 1280px to prevent excessive horizontal line length for reading tour agendas.
- **Tablet (768px - 1199px):** 8 columns, `1.5rem` gutters, and `1.5rem` margins. Complex package booking sidebars reflow below the hero media galleries.
- **Mobile (< 768px):** 4 columns, `1rem` (16px) gutters, and `1rem` margins. Sticky bottom action bar docks the booking CTA, while search filters convert into an intuitive full-height slide-over drawer.
- **Spatial Rhythm:** Component padding scales symmetrically from `0.5rem` (badge insets) to `1.5rem` (card interior padding), avoiding claustrophobic data packing.

## Elevation & Depth

To avoid murky or heavily shaded aesthetics, depth is created through airy tonal tiers, crisp border delineations, and delicate, cyan-diffused ambient luminescence.

- **Ground Level (Elevation 0):** Pure `#F7F9FC` background canvas.
- **Surface Level (Elevation 1):** `#FFFFFF` surfaces with a hairline 1px border of `#E5EAF2` and an ultra-soft ambient shadow: `0 2px 8px -2px rgba(23, 32, 51, 0.04), 0 1px 4px -1px rgba(23, 32, 51, 0.02)`.
- **Card Hover & Interactive Floating (Elevation 2):** Applied to tour cards, destination previews, and search bar widgets. Rises subtly with: `0 12px 24px -6px rgba(0, 102, 255, 0.08), 0 4px 12px -2px rgba(0, 199, 230, 0.06)`, framed by an active border tint of `#D3E2F8`.
- **Overlay & Dropdowns (Elevation 3):** Modal dialogues, date pickers, and booking overlays use `0 20px 32px -8px rgba(23, 32, 51, 0.12)` accompanied by a crisp white surface and `#E5EAF2` stroke.

## Shapes

The interface embraces a friendly, pill-forward design language (`roundedness: 3`). Fully rounded capsules and sweeping corners impart a feeling of comfort, recreation, and fluidity.

- **Interactive Controls (Buttons, Inputs, Badges):** Standardize on full pill geometry (`9999px` / `1rem+` radius) to create welcoming, click-ready affordances.
- **Tour Cards & Booking Modules:** Employ `rounded-lg` (2rem / 32px) outer corners, with inner media thumbnails softly counter-curved at `1.25rem` (20px).
- **Segmented Controls & Filter Tags:** Utilize pill-shaped silhouettes (`rounded-full`) for easy horizontal swiping and tap targeting on touch devices.

## Components

### Buttons
- **Primary CTA:** Pill-shaped background in Deep Ocean Blue (`#0066FF`), white text (`#FFFFFF`), `12px 28px` padding. On hover, shifts to bright Lagoon Cyan (`#00C7E6`) with subtle lift.
- **Secondary Button:** White pill surface with a 1px border in `#0066FF`, text in `#0066FF`. Hover initiates an ultra-light tint fill (`rgba(0, 102, 255, 0.05)`).
- **Ghost/Tertiary:** No border, text in `#172033`, hover highlights with `#F0F4FA`.

### Cards (Tour & Destination)
- Composed of a `#FFFFFF` body encased in a delicate `1px solid #E5EAF2` perimeter.
- Top section holds a 16:9 or 4:3 high-resolution destination image with `1.25rem` inner radius.
- Includes floating badges for tour duration and rating, an `Outfit` semi-bold price display, and an immediate pill-shaped "Book Now / Xem Chi Tiết" trigger.

### Chips & Filter Pills
- Default unselected: `#FFFFFF` fill, `1px solid #E5EAF2`, text `#667085`.
- Active/Selected: Soft cyan-blue fill (`rgba(0, 199, 230, 0.12)`), border `1px solid #00C7E6`, text `#0066FF` with a checkmark indicator.

### Input Fields & Search Bar
- Unified travel search bar featuring pill-shaped segmented inputs (Location, Date, Guests).
- Field containers feature `#FFFFFF` background, `1px solid #E5EAF2` border, with placeholder text in `#667085`.
- Focus state creates a clean, crisp dual-ring using `#00C7E6` without heavy blur halos.

### Checkboxes & Radio Buttons
- High-contrast circular (radios) and rounded-square 6px (checkboxes) widgets in `#FFFFFF` with `#E5EAF2` border.
- Selected state fills with `#0066FF`, presenting a clean white checkmark or center dot.

### Specialized Travel Components
- **Itinerary Timeline:** Clean vertical 2px guide in `#E5EAF2` connecting day-by-day pill milestones tagged with `#00C7E6` indicators.
- **Price Tag Badge:** Compact pill containing sunset amber (`#FF7A00`) highlight for special holiday departures.