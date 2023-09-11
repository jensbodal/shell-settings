#!/usr/bin/env bun

import arg from 'arg';
import chalk from 'chalk';
import { diffChars } from 'diff';
import fs from 'fs';

const cwd = process.cwd();
const gitPath = `${cwd}/.git`;
const gigPath = `${cwd}/.gitignore`;

const green = (...args) => console.log(chalk.green(...args));
const yellow = (...args) => console.warn(chalk.yellow(...args));
const red = (...args) => console.error(chalk.red(...args));

const parseContentToGroups = content => {
  let groups = [];
  let group = -1;
  let inGroup = false;

  content.forEach(line => {
    let isHeader = false;
    if (line.startsWith('#')) {
      isHeader = true;
      if (!inGroup) {
        group++;
      }
      inGroup = true;
    } else {
      inGroup = false;
    }

    group = group === -1 ? 0 : group;

    groups[group] ??= { header: [], group: [] };

    if (isHeader) {
      groups[group].header.push(line || '\n');
    } else {
      groups[group].group.push(line || '\n');
    }
  });

  return groups.map(({header, group}) => {
    const last = group.pop();
    if (last === '\n') {
      return {header, group};
    }
    return {header, group: [...group, last]};
  });
}

const parseFile = (filepath) => {
  return fs.readFileSync(filepath).toString();
}

const parsedToFileContents = (parsed) => {
  return parsed.map(({header, group}) => {
    const headerLines = header.join('');
    const groupLines = group.join('\n').replace(/[\n]{2,}/g, '\n\n');
    if (headerLines) {
      return [headerLines, groupLines, '\n'].join('\n');
    }

    yellow('No header line for:', group.join(' \\n').replace(/(.{30})..+/, "$1..."));

    return [groupLines, '\n'].join('\n');
  }).join('').trim();
}

const writeFile = (filepath, contents) => {
  fs.writeFileSync(filepath, contents);
}

const main = async() => {
  const {'--write': write = false, '--show': show = true} = arg({
      '--show': Boolean,
      '--write': Boolean,

      // Aliases
      '-s': '--show',
      '-w': '--write',
  });

  if (!fs.existsSync(gitPath)) {
    console.log('You are not currently in a git repository');
    console.log('Run "git init" to initialize a git repository');
    return;
  }

  if (!fs.existsSync(gigPath)) {
    console.log('No existing ".gitignore" file, attempting to create one');
    red('This is not yet implemented');
    return;
  }

  green('".gitignore" file exists, updating if needed...');

  const parsed = parseFile(gigPath);
  const content = parseContentToGroups(parsed.split('\n'));
  const newFileContents = parsedToFileContents(content);

  if (show) {
    const diff = diffChars(parsed, newFileContents);
    const output = [];
    console.log([
      chalk.green('[green: additions]'),
      chalk.red('[red: deletions]'),
      chalk.grey('[grey: unchanged]'),
    ].join(' '));

    diff.forEach((part) => {
      // green for additions, red for deletions
      // grey for common parts
      const color = part.added ? 'green' :
        part.removed ? 'red' : 'grey';
      output.push(chalk[color](part.value));
    });

    console.log(output.join('') + '\n');
  }

  if (write) {
    green('Writing new gitignore file');
    writeFile('.gitignore', newFileContents);
    return;
  }

  yellow('Run again with "-w" to write contents to ".gitignore"');
}

main().catch(e => {
  red('An error occurred');
  red(e)
});
