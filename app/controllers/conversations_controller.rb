class ConversationsController < ApplicationController
    before_action :logged_in?

    def index
        conversations = Conversation.all
        conversations = conversations.select{|conversation| conversation.users.map{|user| user.id}.include?(current_user.id)}
        sorted_convos = conversations.each {|convo| convo.messages.sort_by {|msg| msg.id}}
        render json: sorted_convos
    end

    def create
        conversation = Conversation.new(conversation_params)
        if conversation.save
            # stripped = conversation.users {|user| user.id = nil}
            # create UserConversation here
            UserConversation.create(user_id: current_user.id, conversation_id:conversation.id)
            serialized_convo = ActiveModelSerializers::Adapter::Json.new(ConversationSerializer.new(conversation)).serializable_hash
            # offload broadcast to job
            byebug
            render json: serialized_convo
            ActionCable.server.broadcast "conversations_channel", serialized_convo
            head :ok
        end
    end

    def delete
        @conversation = Conversation.find(conversation_params)
        if @conversation.destroy
            render json: "DESTROYED"
        else
            render json: 'ERROR'
        end
    end

    private

        def conversation_params
            params.require(:conversation).permit(:id, :title, :topic, :private)
        end
end
