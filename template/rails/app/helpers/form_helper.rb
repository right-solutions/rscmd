# This module creates Bootstrap wrappers around basic View Tags
module FormHelper
  # Example 1
  #
  #   theme_form_group("Student Name") do
  #     text_field_tag(:student, :name)
  #   end
  #
  # is equivalent to:
  #
  # <div class="form-group ">
  #   <label for="inp_name" class="col-md-4 control-label">Student Name
  #     <span class="text-color-red ml-10 mr-5 pull-right">*</span>
  #   </label>
  #   <div class="col-md-8">
  #     <%= text_field_tag(:student, :name) %>
  #   </div>
  # </div>
  #
  # ---------------------------
  #
  # Example 2
  #
  #   theme_form_group("Please select a Movie", required: false) do
  #     collection_select(@movie_ticket, :movie_id, movies_list, :id, name, {:prompt=>true}, {:class => 'form-control'})
  #   end
  #
  # is equivalent to:
  #
  # <div class="form-group ">
  #   <label for="inp_movie_id" class="col-md-4 control-label">
  #     Please select a Movie
  #   </label>
  #   <div class="col-md-8">
  #     <%= collection_select(@movie_ticket, :movie_id, movies_list, :id, name, {:prompt=>true}, {:class => 'form-control'}) %>
  #   </div>
  # </div>

  # Example 3
  # if you want to change the label div column width which is by default set to "col-md-4"
  # and field div column width which is by default set to "col-md-8" by passing label_col_class and field_col_class
  #
  #   theme_form_group("Please select a Movie", label_col_class: "col-md-6", field_col_class: "col-md-6") do
  #     ....
  #   end
  #

  # Example 4
  # If you want to add error_class to form-group div tag you can pass it through options
  #
  #   theme_form_group("Please select a Movie", error_class: "error-class") do
  #     ....
  #   end
  #

  def theme_form_group(label, **options)
    options.reverse_merge!(
      error_class: "",
      param_name: label.gsub(" ", "_").underscore,
      required: true,
      label_col_class: "col-md-4",
      field_col_class: "col-md-8"
    )

    content_tag(:div, class: "form-group #{options[:error_class]}") do
      content_tag(:label, class: "#{options[:label_col_class]} control-label") do
        star_content = options[:required] ? "*" : raw("&nbsp;&nbsp;")
        raw(label + content_tag(:span, star_content, class: "text-color-red ml-10 mr-5 pull-right"))
      end +
      content_tag(:div, class: options[:field_col_class]) do
        if block_given?
          yield
        else
          "No Block Passed"
        end
      end
    end
  end

  # Creates the form group with label, and text field
  # Supports the following input type: "text", "email", "search", "password", "date", "time", "tel", "url", "month"
  # Example
  #    theme_form_field(@project, :name)
  #
  # <div class="form-group ">
  #    <label class="col-md-4 control-label" for="inp_name">
  #      Name
  #      <span class="text-color-red ml-10 mr-5 pull-right">*</span>
  #    </label>
  #    <div class="col-md-8">
  #     <input class="text input form-control" id="inp_name" name="link_type[name]" placeholder="" type="text">
  #    </div>
  # </div>

  def theme_form_field(object, field_name, **options)
    options.symbolize_keys!
    options.reverse_merge!(
      object_name: object.class.name.underscore,
      label: field_name.to_s.gsub("_", " ").titleize,
      required: true,
      error_class: "has-error",
      html_options: {}
    )
    options.reverse_merge!(
      param_name: "#{options[:object_name]}[#{field_name}]"
    )

    if object.errors[field_name.to_s].any?
      error_class =  options[:error_class]
      error_message = content_tag(:span, object.errors[field_name].first, class: "help-block")
    else
      error_class = ""
      error_message = ""
    end

    theme_form_group(options[:label], required: options[:required], error_class: error_class) do
      options[:html_options].reverse_merge!(
        type: "text",
        id: "inp_#{options[:label].to_s.gsub(" ", "_").downcase}",
        class: "text input form-control",
        place_holder: ""
      )
      case options[:html_options][:type].to_sym
      when :text, :email, :search, :password, :date, :time, :tel, :url, :month
        text_field_tag(options[:param_name], object.send(field_name.to_s), **options[:html_options])
      when :textarea
        options[:html_options].merge!(style: "height: 80px;")
        text_area_tag(options[:param_name], object.send(field_name.to_s), **options[:html_options])
      when :file
        file_field_tag(options[:param_name], **options[:html_options])
      when :checkbox
        options[:html_options][:class] = "checkbox mt-10"
        check_box_tag(options[:param_name], field_name, object.send(field_name.to_s), **options[:html_options])
      end + error_message
    end
  end

  # Example
  #   assoc_collection = Client.select("id, name").order("name ASC").all
  #   options = {assoc_object: client, assoc_display_method: :name, assoc_collection: Client.select("id, name").order("name ASC").all, label: "Client", required: true}
  #   theme_form_assoc_group(project, :client_id, **options)
  # is equivalent to:
  # ---------------------------
  # <% Choose Client - Drop Down  %>
  # <div class="form-group ">
  #   <label for="inp_name" class="col-md-4 control-label">
  #     Client
  #     <span class="text-color-red ml-10 mr-5 pull-right">*</span>
  #   </label>
  #   <div class="col-md-8">
  #     <% if editable && @client %>
  #       <%= @client.name %>
  #       <%= hidden_field_tag "project[client_id]", @client.id %>
  #     <% else %>
  #       <%= collection_select(:project, :client_id, Client.select("id, name").order("name ASC").all, :id, :name, {:prompt=>true}, {:class => 'form-control'}) %>
  #     <% end %>
  #   </div>
  # </div>
  def theme_form_assoc_group(object, foreign_key, **options)
    options.symbolize_keys!
    assoc_method_name = foreign_key.to_s.chomp("_id")
    options.reverse_merge!(
      assoc_object: object.respond_to?(assoc_method_name) ? object.send(assoc_method_name) : nil,
      assoc_display_method: :name,
      assoc_collection: [],
      param_name: object.class.name.underscore,
      object_name: object.class.name.underscore,
      required: true,
      label: foreign_key.to_s.titleize,
      prompt: true,
      editable: true,
      error_class: "has-error"
    )

    # Populating Errors
    errors = object.errors[foreign_key.to_s]
    # if foreign_key is an id, check errors for the association
    # errors = project.errors[:client_id] + project.errors[:client]
    if object.errors[foreign_key.to_s.gsub("_id", "")]
      errors += object.errors[foreign_key.to_s.gsub("_id", "")]
    end

    error_class = errors.any? ? options[:error_class] : ""
    if errors.any?
      error_class =  options[:error_class]
      error_message = content_tag(:span, errors.first, class: "help-block")
    else
      error_class = ""
      error_message = ""
    end

    selected_id = object.send(foreign_key)

    theme_form_group(options[:label], required: options[:required], error_class: error_class) do
      if !options[:editable] && options[:assoc_object]
        raw(options[:assoc_object].send(options[:assoc_display_method]) + hidden_field_tag("#{options[:param_name]}[#{foreign_key}]", options[:assoc_object].id))
      else
        collection_select(options[:object_name], foreign_key, options[:assoc_collection], :id, options[:assoc_display_method], {prompt: options[:prompt], selected: selected_id}, {:class => 'form-control'})
      end + error_message
    end
  end

  # Example
  #   roles = ConfigCenter::Roles::LIST
  #   options_list = Array[*roles.collect {|v,i| [v,v] }].sort
  #   theme_form_select_group(f, @proposal, :plan, options_list, label: "Choose Plan", param_name: "proposal[:plan]", prompt: true)
  # is equivalent to:
  # ---------------------------
  # <div class="form-group ">
  #   <label for="inp_name" class="col-md-4 control-label">Choose Plan
  #     <span class="text-color-red ml-10 mr-5 pull-right">*</span>
  #   </label>
  #   <div class="col-md-8">
  #     <% options_list = ConfigCenter::Roles::LIST %>
  #     <%= f.select("proposal[:plan]", options_for_select(options_list, :selected => f.object.name), {:prompt=>true}, {:class => 'form-control'}) %>
  #   </div>
  # </div>
  def theme_form_select_group(form, object, field_name, options_list, **options)
    options.reverse_merge!(
      label: "Label",
      param_name: "Param",
      prompt: true,
      error_class: "has-error",
      required: false
    )
    error_class = object.errors[field_name.to_s].any? ? options[:error_class] : ""
    if object.errors[field_name.to_s].any?
      error_class =  options[:error_class]
      error_message = content_tag(:span, object.errors[field_name].first, class: "help-block")
    else
      error_class = ""
      error_message = ""
    end

    theme_form_group(options[:label], required: options[:required], error_class: error_class) do
      form.select(options[:param_name], options_for_select(options_list, :selected => object.send(field_name)), {:prompt=>options[:prompt]}, {:class => 'form-control'}) + error_message
    end
  end

  # Creates a submit button with basic styles
  # Example
  #   submit_tag button_text, "data-reset-text"=>button_text, "data-loading-text"=>"Saving ...", :class=>"btn btn-primary ml-10"
  # is equivalent to:
  # ---------------------------
  # submit_tag button_text, "data-reset-text"=>button_text, "data-loading-text"=>"Saving ...", :class=>"btn btn-primary ml-10"
  def theme_form_button(object, button_text="", saving_message="Saving ...", classes="btn btn-primary ml-10")
    button_text = "#{object.new_record? ? "Create" : "Update"}" if button_text.blank?
    submit_tag(button_text, "data-reset-text"=>button_text, "data-loading-text"=>saving_message, :class=>classes)
  end
end