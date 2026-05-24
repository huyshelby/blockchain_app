---
name: Vibrant Marketplace
colors:
  surface: '#fff8f6'
  surface-dim: '#f2d3cd'
  surface-bright: '#fff8f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff0ee'
  surface-container: '#ffe9e5'
  surface-container-high: '#ffe2dc'
  surface-container-highest: '#fbdcd6'
  on-surface: '#281714'
  on-surface-variant: '#5c403a'
  inverse-surface: '#3f2c28'
  inverse-on-surface: '#ffede9'
  outline: '#906f69'
  outline-variant: '#e5beb6'
  surface-tint: '#ba1d00'
  primary: '#b51c00'
  on-primary: '#ffffff'
  primary-container: '#db3416'
  on-primary-container: '#fffbff'
  inverse-primary: '#ffb4a5'
  secondary: '#bb0015'
  on-secondary: '#ffffff'
  secondary-container: '#e51d25'
  on-secondary-container: '#fffbff'
  tertiary: '#785600'
  on-tertiary: '#ffffff'
  tertiary-container: '#976d00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad3'
  primary-fixed-dim: '#ffb4a5'
  on-primary-fixed: '#3e0400'
  on-primary-fixed-variant: '#8e1400'
  secondary-fixed: '#ffdad6'
  secondary-fixed-dim: '#ffb4ac'
  on-secondary-fixed: '#410003'
  on-secondary-fixed-variant: '#93000e'
  tertiary-fixed: '#ffdea6'
  tertiary-fixed-dim: '#ffbb0c'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#5d4200'
  background: '#fff8f6'
  on-background: '#281714'
  surface-variant: '#fbdcd6'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  title-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 12px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-margin: 16px
  gutter: 12px
---

## Brand & Style
The design system is engineered for a high-velocity, modern e-commerce experience. It balances the urgency and excitement of retail with a disciplined, minimalist structure to avoid the visual clutter common in the industry. 

The aesthetic is **Corporate Modern with a Minimalist lens**: it utilizes heavy whitespace to frame professional photography while using vibrant accent colors to drive conversion. The goal is to evoke a sense of reliability, speed, and discovery, ensuring that the interface feels energetic yet organized.

## Colors
The palette is led by a high-visibility **Primary Orange (#FF4D2D)**, used for primary actions and brand presence. A **Secondary Red** is reserved for urgent notifications, flash sales, and price drops. 

The background remains a clean white to maximize product photography pop, while a **Light Gray Surface (#F5F5F5)** is used for section grouping and input backgrounds. Typography uses a **Dark Gray (#1A1A1A)** instead of pure black to maintain a premium feel while ensuring high legibility.

## Typography
The typography system relies exclusively on **Inter** to provide a functional, neutral foundation that handles high data density with ease. 

**Hierarchy Rules:**
- **Price Points:** Use `headline-md` or `headline-lg` in Primary Orange.
- **Product Titles:** Use `body-md` with a maximum of 2 lines.
- **Badges/Labels:** Use `label-sm` for discount tags and technical metadata.
- **Promotional Banners:** Use `display-lg` with tight letter spacing for impact.

## Layout & Spacing
This design system utilizes a **4-column fluid grid** for mobile, with a focus on vertical rhythm built on a **4px baseline**. 

**Key Layout Principles:**
- **Standard Margins:** All screens use a 16px side margin.
- **Grid Density:** Product feeds use a 2-column layout with 12px gutters to balance information density with touch targets.
- **Horizontal Scrolling:** Sections like "Flash Sales" or "Categories" use horizontal carousels that bleed into the margin to signal more content.
- **Safe Areas:** Ensure bottom navigation and sticky headers respect device notches and home indicators.

## Elevation & Depth
Depth is communicated through **Tonal Layering** and **Ambient Shadows**. This design system avoids heavy shadows to maintain a "flat-plus" modern look.

- **Level 0 (Base):** White or Light Gray (#F5F5F5) background.
- **Level 1 (Cards):** White surfaces with a very soft, diffused shadow (0px 4px 12px, 5% opacity of Text Primary).
- **Level 2 (Sticky Headers/Nav):** White surfaces with a subtle bottom-only shadow or a 1px border (#EEEEEE) to separate from scrolling content.
- **Level 3 (Modals/Overlays):** Elevated surfaces with a more pronounced shadow (0px 8px 24px, 10% opacity) and a backdrop dim of 40%.

## Shapes
The shape language is approachable and friendly. 
- **Standard Components:** Buttons and Input fields use 8px (`0.5rem`) rounding.
- **Containers:** Product cards and main section containers use 12px or 16px (`1rem`) to create a soft, modern containerized feel.
- **Badges:** Discount tags and category pills use "Pill-shaped" (fully rounded) corners to distinguish them from structural elements.

## Components

### Product Cards
- **Structure:** 1:1 Aspect ratio image at the top. 12px padding for the text area.
- **Content:** Title (2 lines max), Star rating (Small icons + text), Price (Primary Orange, Bold), and a secondary "sold" count in `body-sm`.
- **Badges:** Small rectangular tags with 4px radius positioned at the top-left of the image for "Mall" or "Local" status.

### Flash Sale Section
- **Countdown:** Uses a secondary red background with white `label-md` text. Square boxes for hours, minutes, and seconds.
- **Progress Bar:** A slim 4px height bar showing stock remaining, using Primary Orange.

### Sticky Search Header
- **Design:** Integrated into a white background. The search bar itself uses the Neutral Surface (#F5F5F5) with a search icon and placeholder text.
- **Actions:** Icons for "Cart" and "Chat" positioned to the right of the search bar.

### Buttons
- **Primary:** Full Primary Orange background, white text, bold weight.
- **Ghost:** Primary Orange border, 1px width, transparent background.
- **Size:** Minimum 48px height for all primary mobile actions.

### Bottom Navigation
- **Style:** Fixed white background with a 1px top border.
- **State:** Active icons use Primary Orange; inactive icons use Text Secondary (#757575). Labels use `label-md`.