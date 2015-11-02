<%inherit file="project/project_base.mako"/>
<%def name="title()">${node['title']} Registrations</%def>
<div id="registrationsListScope">
  <form id="newDraftRegistrationForm" method="POST" style="display:none">
    <!-- ko if: selectedSchema() -->
    <input type="hidden" name="schema_name" data-bind="value: selectedSchema().name">
    <input type="hidden" name="schema_version" data-bind="value: selectedSchema().version">
    <!-- /ko -->
  </form>
<ul id="registrationsTabs" class="nav nav-tabs" role="tablist">
  <li role="presentation" class="active">
    <a id="registrationsControl" aria-controls="registrations" href="#registrations">Registrations</a>
  </li>
  % if 'admin' in user['permissions']:
  <li role="presentation" data-bind="visible: hasDrafts">
      <a id="draftsControl" aria-controls="drafts" href="#drafts">Draft Registrations</a>
  </li>
  % endif
</ul>
<div class="tab-content registrations-view">
  <div role="tabpanel" class="tab-pane active" id="registrations">
    <div class="row" style="min-height: 150px; padding-top:20px;">
      <div class="col-md-9">
        % if node["registration_count"]:
        <div mod-meta='{
            "tpl": "util/render_nodes.mako",
            "uri": "${node["api_url"]}get_registrations/",
            "replace": true,
            "kwargs": {"sortable": false, "pluralized_node_type": "registrations"}
            }'></div>
    ## Uncomment to disable registering Components
    ##% elif node['node_type'] != 'project':
    ##      %if user['is_admin_parent']:
    ##          To register this component, you must <a href="${parent_node['url']}registrations"><b>register its parent project</b></a> (<a href="${parent_node['url']}">${parent_node['title']}</a>).
    ##      %else:
    ##          There have been no registrations of the parent project (<a href="${parent_node['url']}">${parent_node['title']}</a>).
    ##      %endif
        % else:
        <p>
          There have been no completed registrations of this ${node['node_type']}.
          For a list of the most viewed and most recent public registrations on the
          Open Science Framework, click <a href="/explore/activity/#newPublicRegistrations">here</a>,
          or you start a new draft registration from the "Draft Registrations" tab.
        </p>
        % endif
        %if parent_node['exists'] and user['is_admin_parent']:
        <br />
        <br />
        To register the entire project "${parent_node['title']}" instead, click <a href="${parent_node['registrations_url']}">here.</a>
        %endif
      </div>

        % if 'admin' in user['permissions'] and not disk_saving_mode:
            <div class="col-md-3">
        <a data-bind="click: createDraftModal, css: {disabled: loading}" id="registerNode" class="btn btn-default" type="button">
          New Registration
        </a>
            </div>
        % endif
    </div>
  </div>
  <div role="tabpanel" class="tab-pane" id="drafts">
    <div class="row" style="min-height: 150px;padding-top:20px;">
      <div data-bind="visible: !preview()">
        <div class="col-md-9">
          <div class="scripted" data-bind="foreach: drafts">
            <li class="project list-group-item list-group-item-node">
              <h4 data-bind="text: schema().title" ></h4>
              <h4 class="list-group-item-heading">
                <div class="progress progress-bar-md">
                  <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100"
                       data-bind="attr.aria-completion: completion,
                                  style: {width: completion() + '%'}">
                    <span class="sr-only"></span>
                  </div>
                </div>
                <small>
                <p>initiated by: <span data-bind="text: initiator.fullname"></span>
                <p>started: <span data-bind="text: initiated"></span></p>
                <p>last updated: <span data-bind="text: updated"></span></p>
                <span data-bind="if: requiresApproval">
                    <div data-bind="if: isApproved">
                        <div class="draft-status-badge bg-success"> Approved</div>
                    </div>
                    <div data-bind="ifnot: isApproved">
                        <div class="draft-status-badge bg-warning"> Pending Approval </div>
                    </div>
                    <div data-bind="if: isPendingReview">
                        <div class="draft-status-badge bg-warning"> Pending Review</div>
                    </div>
                </span>
                </small>
                <div class="row">
                  <div class="col-md-10">
                    <a class="btn btn-info"
                       data-bind="click: $root.maybeWarn"><i style="margin-right: 5px;" class="fa fa-pencil"></i>Edit</a>
                    <button class="btn btn-danger"
                            data-bind="click: $root.deleteDraft"><i style="margin-right: 5px;" class="fa fa-times"></i>Delete</button>
                  </div>
                  <div class="col-md-1">
                     <a class="btn btn-success" data-bind="attr.href: urls.register_page,
                                                           tooltip: {
                                                             placement: 'top',
                                                             title: isApproved ? 'Finalize this draft' : 'This draft must be approved before it can be registered'
                                                           },
                                                           css: {'disabled': !isApproved}">Register</a>
                  </div>
                </div>
              </h4>
            </li>
          </div>
        </div>
      </div>
      <div data-bind="if: preview">
        <br />
        <button data-bind="click: preview.bind($root, false)"
                class="btn btn-primary"><i class="fa fa-arrow-circle-o-left"></i>&nbsp;&nbsp;&nbsp;Back</button>
        <br />
        <br />
        <p> Select a registration template to continue ... </p>
        <div class="row">
          <form name="createDraft" method="post">
            <div class="col-md-9">
              <div class="form-group">
                <select class="form-control" data-bind="options: schemas,
                                                        optionsText: 'name',
                                                        value: selectedSchema">
                </select>
                <input type="hidden" name="schema_name" data-bind="value: selectedSchema().name" />
                <input type="hidden" name="schema_version" data-bind="value: selectedSchema().version" />
              </div>
            </div>
            <div class="col-md-3">
              <button type="submit" class="btn btn-success"> Start </button>
            </div>
          </form>
        </div>
        <hr />
        <div class="row" data-bind="if: selectedSchema">
          <div class="col-md-12" data-bind="with: selectedSchema">
            <span data-bind="if: requiresApproval">
              <div class="row">
                <div class="col-md-12 schema-fulfillment">
                  <span class="well" data-bind="tooltip: {
                                                  placement: 'top',
                                                  title: 'Site administrations will need to approve this draft before it can be registered'
                                                }">
                    <span>Requires Approval</span>&nbsp;&nbsp;
                    <i class="fa fa-exclamation-triangle" target="_blank"></i>
                  </span>              
                </div>
              </div>
            </span>
            <span data-bind="if: fulfills.length">
              <h4> Fulfills: </h4>
              <div class="row">
                <div class="col-md-12 schema-fulfillment" data-bind="foreach: fulfills">
                  <span class="well">
                    <span data-bind="text: name"></span>&nbsp;&nbsp;
                    <a class="fa fa-info-circle" target="_blank" data-bind="attr.href: info"></a>
                  </span>
                </div>
              </div>
            </span>
            <h4> Description: </h4>
            <blockquote>
              <p data-bind="text: schema.description"></p>
            </blockquote>
          </div>
        </div>
        <hr />
        <div class="row" data-bind="template: {data: previewSchema, name: 'registrationPreview'}">
        </div>
      </div>
    </div>
  </div>
</div>
</div>
<script type="text/html" id="createDraftRegistrationModal">
    <p>Registration creates a frozen version of the project that can never be edited or deleted but can be retracted. Your original project remains editable but will now have the registration linked to it. Things to know about registration:</p>
    <ul>
        <li>Ensure your project is in the state you wish to freeze before registering.</li>
        <li>Consider turning links into forks.</li>
        <li>Registrations can have embargo periods for up to four years. If you choose an embargo period, the registration will automatically become public when the embargo expires.</li>
        <li>Retracting a registration removes the contents of the registrations but will leave behind a log showing when the registration was created and retracted.</li>
    </ul>

    <p>Continue your registration by selecting a registration form:</p>
    <span data-bind="foreach: schemas">
    <div class="radio">
        <label>
          <input type="radio" name="chosenDraftRegistrationTemplate" 
                 data-bind="value: id, checked: $root.selectedSchemaId"/>
          {{ schema.title }}
          <!-- ko if: schema.description -->
          <i data-bind="tooltip: {title: schema.description}" class="fa fa-info-circle"> </i>
          <!-- /ko -->
        </label>
    </div>
    </span>
</script>
<%def name="javascript_bottom()">
    ${parent.javascript_bottom()}

    <script src=${"/static/public/js/project-registrations-page.js" | webpack_asset}> </script>
</%def>

<%include file="project/registration_preview.mako" />
