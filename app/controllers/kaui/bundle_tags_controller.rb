class Kaui::BundleTagsController < Kaui::EngineController

  def show
    bundle_id = params[:id]
    if bundle_id.present?
      begin
        tags = Kaui::KillbillHelper::get_tags_for_bundle(bundle_id, options_for_klient)
      rescue => e
        flash.now[:error] = "Error while retrieving tags information: #{as_string(e)}"
      end
    else
      flash.now[:error] = "No account id given"
    end
  end

  def edit
    @bundle_id = params[:bundle_id]
    begin
      @available_tags = Kaui::KillbillHelper::get_tag_definitions(options_for_klient).sort {|tag_a, tag_b| tag_a.name.downcase <=> tag_b.name.downcase }

      @bundle = Kaui::KillbillHelper::get_bundle(@bundle_id, options_for_klient)
      @tags = Kaui::KillbillHelper::get_tags_for_bundle(@bundle_id, options_for_klient)
    rescue => e
      flash.now[:error] = "Error while retrieving tags information: #{as_string(e)}"
    end
  end

  def update
    begin
      bundle = Kaui::KillbillHelper::get_bundle(params[:bundle_id], options_for_klient)
      tags = params[:tags]

      Kaui::KillbillHelper::set_tags_for_bundle(bundle.bundle_id, tags, current_user, params[:reason], params[:comment], options_for_klient)
      redirect_to Kaui.bundle_home_path.call(bundle.bundle_id)
    rescue => e
      flash.now[:error] = "Error while updating tags: #{as_string(e)}"
    end
  end
end
