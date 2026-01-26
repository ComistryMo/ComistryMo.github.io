import { visit } from 'unist-util-visit';

/**
 * Remark plugin to transform Obsidian-style image syntax to standard Markdown
 * Converts ![[image.png]] to ![image](./images/image.png)
 */
export function remarkObsidianImages() {
  return (tree, file) => {
    visit(tree, 'text', (node, index, parent) => {
      // Match Obsidian image syntax: ![[filename]]
      const obsidianImageRegex = /!\[\[([^\]]+)\]\]/g;
      
      if (obsidianImageRegex.test(node.value)) {
        const matches = [...node.value.matchAll(/!\[\[([^\]]+)\]\]/g)];
        const newNodes = [];
        let lastIndex = 0;
        
        matches.forEach((match) => {
          const [fullMatch, filename] = match;
          const startIndex = match.index;
          
          // Add text before the match
          if (startIndex > lastIndex) {
            newNodes.push({
              type: 'text',
              value: node.value.slice(lastIndex, startIndex)
            });
          }
          
          // Create image node with URL encoding for spaces
          const encodedFilename = filename.replace(/ /g, '%20');
          newNodes.push({
            type: 'image',
            url: `./images/${encodedFilename}`,
            alt: filename.replace(/\.[^/.]+$/, '').replace(/[_-]/g, ' '),
            title: null
          });
          
          lastIndex = startIndex + fullMatch.length;
        });
        
        // Add remaining text after the last match
        if (lastIndex < node.value.length) {
          newNodes.push({
            type: 'text',
            value: node.value.slice(lastIndex)
          });
        }
        
        // Replace the current node with new nodes
        parent.children.splice(index, 1, ...newNodes);
      }
    });
  };
}
