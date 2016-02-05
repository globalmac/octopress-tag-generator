# encoding: utf-8
#
# Jekyll tag page generator.
#
# Based on Jekyll category page generator
# http://recursive-design.com/projects/jekyll-plugins/
#
# Version: 0.0.1
#
# Copyright (c) 2016 GlobalMac,
# Copyright (c) 2010 Dave Perrett, http://recursive-design.com/
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates tag pages for jekyll sites.
#
# Included filters :
# - tag_links:      Outputs the list of categories as comma-separated <a> links.
#
# Available _config.yml settings :
# - tags_dir:          The subfolder to build tag pages in (default is 'categories').
# - tag_title_prefix: The string used before the tag name in the page title (default is
#                          'tag: ').

require 'stringex'

module Jekyll

  # The tagIndex class creates a single tag page for the specified tag.
  class TagIndex < Page

    # Initializes a new tagIndex.
    #
    #  +base+         is the String path to the <source>.
    #  +tags_dir+ is the String path between <source> and the tag folder.
    #  +tag+     is the tag currently being processed.
    def initialize(site, base, tags_dir, tag)
      @site = site
      @base = base
      @dir  = tags_dir
      @name = 'index.html'
      self.process(@name)
      # Read the YAML data from the layout page.
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag']    = tag
      # Set the title for this page.
      title_prefix             = site.config['tag_title_prefix'] || 'tag: '
      self.data['title']       = "#{title_prefix}#{tag}"
      # Set the meta-description for this page.
      meta_description_prefix  = site.config['tag_meta_description_prefix'] || 'tag: '
      self.data['description'] = "#{meta_description_prefix}#{tag}"
    end

  end

  # The tagFeed class creates an Atom feed for the specified tag.
  class TagFeed < Page

    # Initializes a new tagFeed.
    #
    #  +base+         is the String path to the <source>.
    #  +tags_dir+ is the String path between <source> and the tag folder.
    #  +tag+     is the tag currently being processed.
    def initialize(site, base, tags_dir, tag)
      @site = site
      @base = base
      @dir  = tags_dir
      @name = 'atom.xml'
      self.process(@name)
      # Read the YAML data from the layout page.
      self.read_yaml(File.join(base, '_includes'), 'tag_feed.xml')
      self.data['tag']    = tag
      # Set the title for this page.
      title_prefix             = site.config['tag_title_prefix'] || 'tag: '
      self.data['title']       = "#{title_prefix}#{tag}"
      # Set the meta-description for this page.
      meta_description_prefix  = site.config['tag_meta_description_prefix'] || 'tag: '
      self.data['description'] = "#{meta_description_prefix}#{tag}"

      # Set the correct feed URL.
      self.data['feed_url'] = "#{tags_dir}/#{name}"
    end

  end

  # The Site class is a built-in Jekyll class with access to global site config information.
  class Site

    # Creates an instance of tagIndex for each tag page, renders it, and
    # writes the output to a file.
    #
    #  +tags_dir+ is the String path to the tag folder.
    #  +tag+     is the tag currently being processed.
    def write_tag_index(tags_dir, tag)
      index = TagIndex.new(self, self.source, tags_dir, tag)
      index.render(self.layouts, site_payload)
      index.write(self.dest)
      # Record the fact that this page has been added, otherwise Site::cleanup will remove it.
      self.pages << index

      # Create an Atom-feed for each index.
      feed = TagFeed.new(self, self.source, tags_dir, tag)
      feed.render(self.layouts, site_payload)
      feed.write(self.dest)
      # Record the fact that this page has been added, otherwise Site::cleanup will remove it.
      self.pages << feed
    end

    # Loops through the list of tag pages and processes each one.
    def write_tag_indexes
      if self.layouts.key? 'tag_index'
        dir = self.config['tags_dir'] || 'tags'
        self.tags.keys.each do |tag|
          self.write_tag_index(File.join(dir, tag.to_url), tag)
        end

      # Throw an exception if the layout couldn't be found.
      else
        raise <<-ERR


===============================================
 Error for tag_generator.rb plugin
-----------------------------------------------
 No 'tag_index.html' in source/_layouts/
 Perhaps you haven't installed a theme yet.
===============================================

ERR
      end
    end

  end


  # Jekyll hook - the generate method is called by jekyll, and generates all of the tag pages.
  class GenerateTags < Generator
    safe true
    priority :low

    def generate(site)
      site.write_tag_indexes
    end

  end


  # Adds some extra filters used during the tag creation process.
  module Filters

    # Outputs a list of categories as comma-separated <a> links. This is used
    # to output the tag list for each post on a tag page.
    #
    #  +categories+ is the list of categories to format.
    #
    # Returns string
    #
    def tag_links(tags)
      tags.sort.map { |c| tag_link c }.join(' ')
    end

    # Outputs a single tag as an <a> link.
    #
    #  +tag+ is a tag string to format as an <a> link
    #
    # Returns string
    #
    def tag_link(tag)
      dir = @context.registers[:site].config['tags_dir']
      "<a class='tag' href='/#{dir}/#{tag.to_url}/'>#{tag}</a>"
    end


  end

end
