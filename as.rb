require_relative 'model'

module Plugin::MiktpubModel; module AS

  base = Proc.new do

    field_base_uri 'https://www.w3.org/ns/activitystreams#'

    private def field_uri(field_name, base_uri)
      camelized_name = field_name.split('_').each_with_index.map do |part, index|
        if index == 0 then part else part.capitalize(:ascii) end
      end.join('')
      super(camelized_name, base_uri)
    end
  end

  # Core Types
  BaseObject = Type.new(&base)
  Link = Type.new(&base)
  Activity = Type.new(BaseObject)
  IntransitiveActivity = Type.new(Activity)
  Collection = Type.new(BaseObject)
  OrderedCollection = Type.new(Collection)
  CollectionPage = Type.new(Collection)
  OrderedCollectionPage = Type.new(OrderedCollection, CollectionPage)

  # Activity Types
  Accept = Type.new(Activity)
  TentativeAccept = Type.new(Accept)
  Add = Type.new(Activity)
  Announce = Type.new(Activity)
  Arrive = Type.new(IntransitiveActivity)
  Create = Type.new(Activity)
  Delete = Type.new(Activity)
  Dislike = Type.new(Activity)
  Flag = Type.new(Activity)
  Follow = Type.new(Activity)
  Ignore = Type.new(Activity)
  Block = Type.new(Ignore)
  Join = Type.new(Activity)
  Leave = Type.new(Activity)
  Like = Type.new(Activity)
  View = Type.new(Activity)
  Listen = Type.new(Activity)
  Read = Type.new(Activity)
  Move = Type.new(Activity)
  Travel = Type.new(IntransitiveActivity)
  Offer = Type.new(Activity)
  Invite = Type.new(Offer)
  Question = Type.new(IntransitiveActivity)
  Reject = Type.new(Activity)
  TentativeReject = Type.new(Reject)
  Remove = Type.new(Activity)
  Undo = Type.new(Activity)
  Update = Type.new(Activity)

  # Actor Types
  Application = Type.new(BaseObject)
  Group = Type.new(BaseObject)
  Person = Type.new(BaseObject)
  Organization = Type.new(BaseObject)
  Service = Type.new(BaseObject)

  # Object Types
  Article = Type.new(BaseObject)
  Relationship = Type.new(BaseObject)
  Document = Type.new(BaseObject)
  Audio = Type.new(Document)
  Image = Type.new(Document)
  Video = Type.new(Document)
  Event = Type.new(BaseObject)
  Note = Type.new(BaseObject)
  Page = Type.new(BaseObject)
  Profile = Type.new(BaseObject)
  Place = Type.new(BaseObject)
  Tombstone = Type.new(BaseObject)

  # Link Type
  Mention = Type.new(Link)

  # Properties
  Activity.define_field :actor, [BaseObject, Link]
  BaseObject.define_field :attachment, [BaseObject, Link]
  BaseObject.define_field :attributed_to, [BaseObject, Link]
  Link.define_field :attributed_to, [BaseObject, Link]
  BaseObject.define_field :audience, [BaseObject, Link]
  BaseObject.define_field :bcc, [BaseObject, Link]
  BaseObject.define_field :bto, [BaseObject, Link]
  BaseObject.define_field :cc, [BaseObject, Link]
  BaseObject.define_field :context, [BaseObject, Link]
  Collection.define_field :current, [CollectionPage, Link]
  Collection.define_field :first, [CollectionPage, Link]
  BaseObject.define_field :generator, [BaseObject, Link]
  BaseObject.define_field :icon, [Image, Link]
  BaseObject.define_field :image, [Image, Link]
  BaseObject.define_field :in_reply_to, [BaseObject, Link]
  Activity.define_field :instrument, [BaseObject, Link]
  Collection.define_field :last, [CollectionPage, Link]
  BaseObject.define_field :location, [BaseObject, Link]
  Collection.define_field :items, [[BaseObject, Link]]
  Question.define_field :one_of, [BaseObject, Link]
  Question.define_field :any_of, [BaseObject, Link]
  Question.define_field :closed, [BaseObject, Link, :time, :bool]
  Activity.define_field :origin, [BaseObject, Link]
  CollectionPage.define_field :next, [CollectionPage, Link]
  Activity.define_field :object, [BaseObject, Link]
  IntransitiveActivity.define_field :object, :null
  Relationship.define_field :object, [BaseObject, Link]
  CollectionPage.define_field :prev, [CollectionPage, Link]
  BaseObject.define_field :preview, [BaseObject, Link]
  Link.define_field :preview, [BaseObject, Link]
  Activity.define_field :result, [BaseObject, Link]
  BaseObject.define_field :replies, [BaseObject, Link]
  BaseObject.define_field :tag, [BaseObject, Link]
  Activity.define_field :target, [BaseObject, Link]
  BaseObject.define_field :to, [BaseObject, Link]
  BaseObject.define_field :url, [:uri, Model[Link]]
  Place.define_field :accuracy, :float
  Place.define_field :altitude, :float
  BaseObject.define_field :content, :string
  BaseObject.define_field :name, :string
  Link.define_field :name, :string
  BaseObject.define_field :duration, :string # TODO: more precise definition
  Link.define_field :height, :int
  Link.define_field :href, :uri
  Link.define_field :hreflang, :string # TODO: more precise definition
  CollectionPage.define_field :part_of, [Collection, Link]
  Place.define_field :latitude, :float
  Place.define_field :longitude, :float
  BaseObject.define_field :media_type, :string
  Link.define_field :media_type, :string
  BaseObject.define_field :end_time, :time
  BaseObject.define_field :published, :time
  BaseObject.define_field :start_time, :time
  Place.define_field :radius, :float
  Link.define_field :rel, :string
  OrderedCollectionPage.define_field :start_index, :int
  BaseObject.define_field :summary, :string
  Collection.define_field :total_items, :int
  Place.define_field :units, [:string, :uri]
  BaseObject.define_field :updated, :time
  Link.define_field :width, :int
  Relationship.define_field :subject, [BaseObject, Link]
  Relationship.define_field :relationship, [BaseObject, :uri, :string]
  Profile.define_field :describes, Model[BaseObject]
  Tombstone.define_field :former_type, Model[BaseObject]
  Tombstone.define_field :deleted, :time

end; end
