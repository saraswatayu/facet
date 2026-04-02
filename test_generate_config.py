#!/usr/bin/env python3
"""Unit tests for scripts/generate-config.py."""

import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'scripts'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from generate_config import match_study_type, validate_config, generate_study_config_file, generate_run_config, auto_scale, generate_calibration_file
from parse_config import parse_frontmatter


class TestAutoScale(unittest.TestCase):

    def test_quick_check(self):
        data = {'research_question': 'Quick sanity check on pricing', 'options': [{'name': 'A'}, {'name': 'B'}]}
        segments, pps = auto_scale(data)
        self.assertEqual(segments, 4)
        self.assertEqual(pps, 3)

    def test_standard_ab(self):
        data = {'research_question': 'Should I charge $15 or $30?', 'options': [{'name': 'A'}, {'name': 'B'}]}
        segments, pps = auto_scale(data)
        self.assertEqual(segments, 5)
        self.assertEqual(pps, 5)

    def test_deep_lifecycle(self):
        data = {'research_question': 'Full audit of our product', 'options': [{'name': 'A'}]}
        segments, pps = auto_scale(data)
        self.assertEqual(segments, 6)
        self.assertEqual(pps, 8)

    def test_many_options_scales_up(self):
        data = {'research_question': 'Compare these tiers', 'options': [{'name': f'Opt{i}'} for i in range(6)]}
        segments, pps = auto_scale(data)
        self.assertEqual(segments, 6)
        self.assertEqual(pps, 8)

    def test_default_without_explicit_count(self):
        """generate_run_config uses auto_scale when segments/personas_per_segment not provided."""
        data = {
            'product_name': 'TestApp',
            'product_description': 'A test app.',
            'research_question': 'Should I charge $10 or $20?',
            'options': [{'name': 'A', 'description': '$10'}, {'name': 'B', 'description': '$20'}],
        }
        output_dir = tempfile.mkdtemp(prefix='facet-test-scale-')
        try:
            ex_path, _ = generate_study_config_file(data, output_dir)
            study_path = generate_run_config(data, [ex_path], output_dir)
            fm, _ = parse_frontmatter(study_path)
            # A/B question → 5 segments × 5
            self.assertEqual(fm['segments'], 5)
            self.assertEqual(fm['personas_per_segment'], 5)
        finally:
            shutil.rmtree(output_dir, ignore_errors=True)


class TestStudyTypeMatching(unittest.TestCase):

    def test_pricing_keywords(self):
        self.assertEqual(match_study_type("Should I charge $15 or $30?"), 'pricing')
        self.assertEqual(match_study_type("What price should we set?"), 'pricing')
        self.assertEqual(match_study_type("Freemium or paid subscription?"), 'pricing')

    def test_copy_keywords(self):
        self.assertEqual(match_study_type("Which headline works better?"), 'copy')
        self.assertEqual(match_study_type("Test our new positioning tagline"), 'copy')

    def test_features_keywords(self):
        self.assertEqual(match_study_type("Should we build AI time estimates?"), 'features')
        self.assertEqual(match_study_type("Is this feature worth adding?"), 'features')

    def test_onboarding_keywords(self):
        self.assertEqual(match_study_type("Which signup flow keeps users?"), 'onboarding')
        self.assertEqual(match_study_type("How should we onboard new users?"), 'onboarding')

    def test_retention_keywords(self):
        self.assertEqual(match_study_type("Why are users churning?"), 'retention')
        self.assertEqual(match_study_type("How do we keep users engaged?"), 'retention')

    def test_no_match_returns_custom(self):
        self.assertEqual(match_study_type("What color should the logo be?"), 'custom')
        self.assertEqual(match_study_type(""), 'custom')


class TestConfigGeneration(unittest.TestCase):

    def setUp(self):
        self.output_dir = tempfile.mkdtemp(prefix='facet-test-')

    def tearDown(self):
        shutil.rmtree(self.output_dir, ignore_errors=True)

    def _base_data(self):
        return {
            'product_name': 'TestApp',
            'product_description': 'A test application for unit testing.',
            'research_question': 'Should we charge $10 or $20?',
            'study_type': 'pricing',
            'segments': 4,
            'personas_per_segment': 6,
            'options': [
                {'name': 'Basic', 'description': '$10/month'},
                {'name': 'Pro', 'description': '$20/month'},
            ],
        }

    def test_study_config_valid(self):
        data = self._base_data()
        filepath, name = generate_study_config_file(data, self.output_dir)
        self.assertTrue(os.path.exists(filepath))
        errors = validate_config(filepath, 'study')
        self.assertEqual(errors, [])

    def test_study_config_valid(self):
        data = self._base_data()
        ex_path, _ = generate_study_config_file(data, self.output_dir)
        study_path = generate_run_config(data, [ex_path], self.output_dir)
        self.assertTrue(os.path.exists(study_path))
        errors = validate_config(study_path, 'run')
        self.assertEqual(errors, [])

    def test_study_config_has_required_fields(self):
        data = self._base_data()
        ex_path, _ = generate_study_config_file(data, self.output_dir)
        study_path = generate_run_config(data, [ex_path], self.output_dir)

        fm, body = parse_frontmatter(study_path)

        self.assertEqual(fm['segments'], 4)
        self.assertEqual(fm['personas_per_segment'], 6)
        self.assertIn('studies', fm)
        self.assertIn('TestApp', body)

    def test_study_config_has_required_fields(self):
        data = self._base_data()
        filepath, _ = generate_study_config_file(data, self.output_dir)

        fm, _ = parse_frontmatter(filepath)

        self.assertEqual(fm['study_name'], 'testapp-pricing')
        self.assertEqual(fm['study_type'], 'pricing')
        self.assertIsInstance(fm['options'], list)
        self.assertEqual(len(fm['options']), 2)

    def test_empty_options_fails_validation(self):
        data = self._base_data()
        data['options'] = []
        filepath, _ = generate_study_config_file(data, self.output_dir)
        errors = validate_config(filepath, 'study')
        self.assertTrue(any('non-empty' in e for e in errors))

    def test_long_description_truncated(self):
        data = self._base_data()
        data['product_description'] = ' '.join(['word'] * 600)
        ex_path, _ = generate_study_config_file(data, self.output_dir)
        study_path = generate_run_config(data, [ex_path], self.output_dir)
        with open(study_path) as f:
            content = f.read()
        # Body should be truncated to ~500 words + ...
        body_start = content.find('---', 3)
        body = content[body_start + 3:]
        word_count = len(body.split())
        self.assertLessEqual(word_count, 520)

    def test_calibration_context_generates_file(self):
        data = self._base_data()
        data['calibration_context'] = 'Users pay $5-15 for similar tools.'
        ex_path, _ = generate_study_config_file(data, self.output_dir)
        generate_run_config(data, [ex_path], self.output_dir)
        cal_path = os.path.join(self.output_dir, 'calibration.md')
        generate_calibration_file(data['calibration_context'], self.output_dir)
        self.assertTrue(os.path.exists(cal_path))
        with open(cal_path) as f:
            self.assertIn('Users pay $5-15', f.read())


class TestCLIEntrypoint(unittest.TestCase):

    def setUp(self):
        self.output_dir = tempfile.mkdtemp(prefix='facet-test-cli-')

    def tearDown(self):
        shutil.rmtree(self.output_dir, ignore_errors=True)

    def test_valid_json_produces_config(self):
        data = {
            'product_name': 'CLITest',
            'research_question': 'Price this?',
            'options': [{'name': 'A', 'description': '$10'}, {'name': 'B', 'description': '$20'}],
        }
        result = subprocess.run(
            ['python3', 'scripts/generate_config.py', '--output-dir', self.output_dir],
            input=json.dumps(data), capture_output=True, text=True,
            cwd=os.path.dirname(os.path.abspath(__file__)),
        )
        self.assertEqual(result.returncode, 0, f'stderr: {result.stderr}')
        self.assertTrue(result.stdout.strip().endswith('.md'))

    def test_invalid_json_exits_nonzero(self):
        result = subprocess.run(
            ['python3', 'scripts/generate_config.py', '--output-dir', self.output_dir],
            input='not json', capture_output=True, text=True,
            cwd=os.path.dirname(__file__) or '.',
        )
        self.assertNotEqual(result.returncode, 0)

    def test_missing_product_name_exits_nonzero(self):
        result = subprocess.run(
            ['python3', 'scripts/generate_config.py', '--output-dir', self.output_dir],
            input='{"research_question": "test"}', capture_output=True, text=True,
            cwd=os.path.dirname(__file__) or '.',
        )
        self.assertNotEqual(result.returncode, 0)


if __name__ == '__main__':
    unittest.main()
