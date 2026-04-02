#!/usr/bin/env python3
"""Unit tests for Facet utility functions."""

import os
import tempfile
import unittest

from parse_config import parse_frontmatter


class TestParseFrontmatter(unittest.TestCase):

    def _write_temp(self, content):
        f = tempfile.NamedTemporaryFile(mode='w', suffix='.md', delete=False)
        f.write(content)
        f.close()
        self.addCleanup(os.unlink, f.name)
        return f.name

    def test_scalar_values(self):
        path = self._write_temp('---\nsegments: 6\npersonas_per_segment: 8\n---\n# Product\n')
        fm, body = parse_frontmatter(path)
        self.assertEqual(fm['segments'], 6)
        self.assertEqual(fm['personas_per_segment'], 8)
        self.assertIn('# Product', body)

    def test_string_values(self):
        path = self._write_temp('---\nstudy_name: pricing-tiers\nstudy_type: pricing\n---\n')
        fm, _ = parse_frontmatter(path)
        self.assertEqual(fm['study_name'], 'pricing-tiers')
        self.assertEqual(fm['study_type'], 'pricing')

    def test_studies_array(self):
        content = '---\nsegments: 6\nstudies:\n  - config: ex1.md\n  - config: ex2.md\n---\n# Body\n'
        path = self._write_temp(content)
        fm, body = parse_frontmatter(path)
        self.assertEqual(len(fm['studies']), 2)
        self.assertEqual(fm['studies'][0]['config'], 'ex1.md')
        self.assertEqual(fm['studies'][1]['config'], 'ex2.md')
        self.assertEqual(body, '# Body')

    def test_no_frontmatter(self):
        path = self._write_temp('# Just a markdown file\nNo frontmatter here.')
        fm, body = parse_frontmatter(path)
        self.assertEqual(fm, {})
        self.assertIn('Just a markdown', body)

    def test_empty_frontmatter(self):
        path = self._write_temp('---\n---\n# Body\n')
        fm, body = parse_frontmatter(path)
        self.assertEqual(fm, {})
        self.assertIn('# Body', body)

    def test_missing_key(self):
        path = self._write_temp('---\nsegments: 5\n---\n')
        fm, _ = parse_frontmatter(path)
        self.assertIsNone(fm.get('nonexistent'))

    def test_quoted_values(self):
        path = self._write_temp('---\nname: "my study"\n---\n')
        fm, _ = parse_frontmatter(path)
        self.assertEqual(fm['name'], 'my study')

    def test_body_extraction(self):
        content = '---\nkey: value\n---\n\n# Title\n\nParagraph one.\n\nParagraph two.\n'
        path = self._write_temp(content)
        _, body = parse_frontmatter(path)
        self.assertIn('# Title', body)
        self.assertIn('Paragraph one.', body)
        self.assertIn('Paragraph two.', body)

    def test_options_array(self):
        content = """---
study_name: test
options:
  - name: "Option A"
    description: "First option"
  - name: "Option B"
    description: "Second option"
---
"""
        path = self._write_temp(content)
        fm, _ = parse_frontmatter(path)
        self.assertEqual(len(fm['options']), 2)
        self.assertEqual(fm['options'][0]['name'], 'Option A')

    def test_triple_dash_in_yaml_value(self):
        """Ensure --- inside a YAML string value doesn't break frontmatter parsing."""
        content = '---\nstudy_name: pricing\ndescription: "this---premium---option"\n---\n# Body\n'
        path = self._write_temp(content)
        fm, body = parse_frontmatter(path)
        self.assertEqual(fm['study_name'], 'pricing')
        self.assertEqual(fm['description'], 'this---premium---option')
        self.assertIn('# Body', body)


if __name__ == '__main__':
    unittest.main()
