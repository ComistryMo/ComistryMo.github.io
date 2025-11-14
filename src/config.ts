import { BookOpen, FileText, Flower2, CodeXml } from "@lucide/astro";

export interface SocialLinks {
  github?: string;
  linkedin?: string;
  twitter?: string;
  bluesky?: string;
  instagram?: string;
  youTube?: string;
  codetips?: string;
  bilibili?: string;
  xiaohongshu?: string;
}

export interface ExtraLink {
  link: string;     // URL 或站内路径
  icon: any;        // Lucide 图标组件
  label: string;    // 提示文案
}

export interface ExtraLinks {
  enable: boolean;
  links: ExtraLink[];
}

export interface SectionsConfig {
  about: boolean;
  projects: boolean;
  blog: boolean;
  work: boolean;
  education: boolean;
  hackathons: boolean;
  contact: boolean;
}

export interface SiteConfig {
  name: string;
  title: string;
  description?: string;
  avatar?: string;
  location: string;
  email: string;
  socialLinks: SocialLinks;
  enableThemeSelector: boolean;
  extraLinks: ExtraLinks;
  sections: SectionsConfig;
}

export const siteConfig: SiteConfig = {
  name: "ComistryMo",
  title: "身在高处便是靶，我只引弓对苍穹",
  location: "China",
  email: "comistrymo@gmail.com",
  socialLinks: {
    github: "https://github.com/ComistryMo/",
    bilibili: "https://space.bilibili.com/249617096",
    xiaohongshu: "https://www.xiaohongshu.com/user/你的ID",
  },
  enableThemeSelector: true,
  extraLinks: {
    enable: true,
    links: [
      {
        link: "/blog",
        icon: BookOpen,
        label: "Blog Guide",
      },
      {
        link: "/blog/categories/essay",
        icon: Flower2,
        label: "essay",
      },
      {
        link: "/blog/categories/llms",
        icon: FileText,
        label: "LLMs",
      },
      {
        link: "/blog/categories/competitive-programming",
        icon: CodeXml,
        label: "Competitive Programming",
      },
    ],
  },
  sections: {
    about: true,
    projects: false,
    blog: true,
    work: true,
    education: false,
    hackathons: false,
    contact: false,
  },
};
