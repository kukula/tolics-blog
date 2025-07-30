# Tolics Engineering Mind

A personal blog about software architecture, AI, automation, and neurodivergent-friendly systems.

## About

This is the personal blog of Tolic Kukul, a Staff Software Engineer with 20+ years of experience building scalable systems. The blog explores topics at the intersection of technology and human behavior, with a particular focus on:

- AI-native architecture and intelligent agents
- Event-driven systems and real-time processing
- Software design patterns and abstractions
- Neurodivergent-friendly development workflows
- Engineering leadership and team dynamics

## Tech Stack

- **Static Site Generator**: Hugo
- **Theme**: FreeRange

## Getting Started

### Prerequisites

- Hugo (Extended version recommended)
- Git

### Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd tolics-blog
```

2. Start the Hugo development server:
```bash
hugo server -D
```

3. Open your browser to `http://localhost:1313`

### Building for Production

```bash
hugo
```

The static site will be generated in the `public/` directory.

## Content Structure

- `/content/posts/` - Blog posts
- `/content/about.md` - About page
- `/static/css/` - Custom CSS overrides
- `/layouts/` - Custom layout overrides

## Writing New Posts

Create a new post in the `/content/posts/` directory:

```bash
hugo new posts/my-new-post.md
```

Use STYLE_GUIDE.md

## Configuration

Site configuration is in `hugo.toml`. Key settings include:

- Site title and description
- Theme settings (dark mode enabled by default)
- Menu structure
- Social links

## Deployment

The site is built and deployed automatically. The `public/` directory contains the generated static files.

## License

All blog content is copyright Tolic Kukul. The Hugo framework has it's own license.
